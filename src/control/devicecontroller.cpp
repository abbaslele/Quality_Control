#include "DeviceController.h"
#include "../serial/SerialPortManager.h"
#include <QDebug>
#include <cmath>

DeviceController::DeviceController(SerialPortManager *serialPort, QObject *parent)
    : QObject(parent)
    , m_serialPort(serialPort)
    , m_currentEncoderAngle(0.0)
    , m_currentServoPosition(SERVO_ZERO_POSITION)
    , m_positionError(0.0)
{
    if (m_serialPort) {
        connect(m_serialPort, &SerialPortManager::dataReceived,
                this, &DeviceController::handleSerialData);
    }
}

bool DeviceController::sendServoCommand(int microseconds)
{
    if (!m_serialPort) {
        emit deviceError("Serial port manager not available");
        return false;
    }

    if (microseconds < 900 || microseconds > 2250) {
        emit deviceError(QString("Invalid servo position: %1 (range: 900-2250)").arg(microseconds));
        return false;
    }

    QString command = QString("%1%2").arg(SERVO_CMD_PREFIX).arg(microseconds);
    bool success = m_serialPort->writeData(command);

    if (success) {
        m_currentServoPosition = microseconds;
        emit servoPositionChanged(microseconds);
        emit commandSent(command);
        qDebug() << "Servo command sent:" << microseconds;
    }

    return success;
}

bool DeviceController::requestEncoderReading()
{
    if (!m_serialPort) {
        emit deviceError("Serial port manager not available");
        return false;
    }

    bool success = m_serialPort->writeData(ENCODER_READ_CMD);
    if (success) {
        emit commandSent(ENCODER_READ_CMD);
        qDebug() << "Encoder read requested";
    }

    return success;
}

bool DeviceController::calibrateEncoder()
{
    if (!m_serialPort) {
        emit deviceError("Serial port manager not available");
        return false;
    }

    bool success = m_serialPort->writeData(ENCODER_ZERO_CMD);
    if (success) {
        emit commandSent(ENCODER_ZERO_CMD);
        qDebug() << "Encoder calibration command sent";
    }

    return success;
}

void DeviceController::setServoToZero()
{
    sendServoCommand(SERVO_ZERO_POSITION);
}

double DeviceController::mapPulseToAngle(int pulse, int startPulse, int endPulse,
                                         double startAngle, double endAngle) const
{
    if (endPulse == startPulse) {
        return startAngle;
    }

    double ratio = static_cast<double>(pulse - startPulse) / (endPulse - startPulse);
    return startAngle + ratio * (endAngle - startAngle);
}

void DeviceController::handleSerialData(const QString &data)
{
    // Check for servo acknowledgment
    if (data.startsWith("Servo command accepted:")) {
        emit commandAcknowledged(data);
        return;
    }

    // Check for encoder zero confirmation
    if (data.contains("Encoder is ready and set to Zero position")) {
        m_currentEncoderAngle = 0.0;
        emit encoderAngleChanged(0.0);
        emit commandAcknowledged(data);
        return;
    }

    // Parse encoder angle response
    parseEncoderResponse(data);
}

void DeviceController::parseEncoderResponse(const QString &response)
{
    bool ok = false;
    double angle = response.toDouble(&ok);

    if (ok) {
        // Normalize angle to -180 to +180 range
        while (angle > 180.0) angle -= 360.0;
        while (angle < -180.0) angle += 360.0;

        m_currentEncoderAngle = angle;
        emit encoderAngleChanged(angle);
        qDebug() << "Encoder angle updated:" << angle;
    } else {
        qWarning() << "Failed to parse encoder response:" << response;
    }
}

void DeviceController::calculatePositionError(int servoPulse, double encoderAngle)
{
    // This should be called externally with expected angle
    // Error = Expected - Actual
    m_positionError = encoderAngle; // Placeholder, will be calculated in ApplicationController
    emit positionErrorChanged(m_positionError);
}
