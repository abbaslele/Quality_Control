#include "ServoController.h"
#include "../serial/ServoDevice.h"
#include <QDebug>

ServoController::ServoController(QObject *parent)
    : QObject(parent)
    , m_servoDevice(nullptr)
    , m_currentPosition(1500) // Default center position
    , m_isActive(false)
{
}

ServoController::~ServoController()
{
    stop();
}

void ServoController::setServoDevice(ServoDevice *device)
{
    m_servoDevice = device;

    if (m_servoDevice) {
        connect(m_servoDevice, &ServoDevice::errorOccurred,
                this, &ServoController::errorOccurred);
    }
}

bool ServoController::setPosition(int position)
{
    // if (!m_isActive) {
    //     qWarning() << "ServoController not active";
    //     return false;
    // }

    if (!m_servoDevice) {
        emit errorOccurred(QStringLiteral("No servo device configured"));
        return false;
    }

    // Validate position range based on Arduino servo limits
    if (position < 900 || position > 2250) {
        emit errorOccurred(QStringLiteral("Position out of range [900-2250]"));
        return false;
    }

    if (m_servoDevice->sendPositionCommand(position)) {
        m_currentPosition = position;
        emit positionChanged(m_currentPosition);
        qDebug() << "Servo position set to:" << position;
        return true;
    } else {
        emit errorOccurred(QStringLiteral("Failed to send position command"));
        return false;
    }
}

void ServoController::start()
{
    setActive(true);
}

void ServoController::stop()
{
    setActive(false);
}

void ServoController::setActive(bool active)
{
    if (m_isActive != active) {
        m_isActive = active;
        emit activeChanged(m_isActive);
    }
}
