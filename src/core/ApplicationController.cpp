#include "ApplicationController.h"
#include <QSerialPortInfo>
#include <QDebug>
#include <QDateTime>
#include <QSettings>
#include <QThread>

ApplicationController::ApplicationController(QObject *parent)
    : QObject(parent)
    , m_device(new DeviceController(this))
    , m_sequencer(new PositionSequencer(this))
    , m_encoderCenterOffset(0.0f)
    , m_isCalibrated(false)
    , m_currentCommandedPosition(0)
    , m_currentCommandedAngle(0.0f)
    , m_currentPosition(0)
    , m_currentAngle(0.0f)
    , m_maxError(0.0f)
    , m_servoFailed(false)
{
    // Load calibration
    QSettings settings;
    if (settings.contains("encoderCenterOffset")) {
        m_encoderCenterOffset = settings.value("encoderCenterOffset").toFloat();
        m_isCalibrated = true;
        logError(QString("[SYSTEM] Loaded encoder calibration: %1°").arg(m_encoderCenterOffset, 0, 'f', 3));
    }

    connect(m_device, &DeviceController::connectionChanged,
            this, &ApplicationController::deviceConnectionChanged);
    connect(m_device, &DeviceController::positionAcknowledged,
            this, &ApplicationController::onDevicePositionAck);
    connect(m_device, &DeviceController::angleReceived,
            this, &ApplicationController::onDeviceAngleReceived);
    connect(m_device, &DeviceController::errorOccurred,
            this, &ApplicationController::onDeviceError);
    connect(m_sequencer, &PositionSequencer::positionTriggered,
            this, &ApplicationController::onSequencerPosition);
    connect(m_sequencer, &PositionSequencer::runningChanged,
            this, &ApplicationController::sequenceRunningChanged);
}

ApplicationController::~ApplicationController()
{
    stopSequence();
}

QStringList ApplicationController::availablePorts() const
{
    QStringList ports;
    for (const QSerialPortInfo &info : QSerialPortInfo::availablePorts()) {
        ports.append(info.portName());
    }
    return ports;
}

void ApplicationController::connectDevice(const QString &portName)
{
    if (m_device->isConnected()) {
        disconnectDevice();
    }
    m_device->connectDevice(portName);
}

void ApplicationController::disconnectDevice()
{
    m_device->disconnectDevice();
}

void ApplicationController::startSequence()
{
    if (!m_device->isConnected()) {
        emit errorOccurred("Device not connected");
        return;
    }
    if (!m_isCalibrated) {
        emit errorOccurred("Device not calibrated! Click 'Calibrate' first.");
        return;
    }

    resetErrorTracking();
    m_sequencer->start();
}

void ApplicationController::stopSequence()
{
    m_sequencer->stop();
}

void ApplicationController::calibrateDevice()
{
    if (!m_device->isConnected()) {
        emit errorOccurred("Device not connected");
        return;
    }

    logError("[CALIBRATION] Starting...");
    logError("[CALIBRATION] Moving servo to center (1500μs)...");
    logError("[CALIBRATION] Wait 2 seconds for stability...");

    m_device->sendPosition(1500);

    QTimer::singleShot(2000, [this]() {
        m_encoderCenterOffset = m_currentAngle;
        m_isCalibrated = true;

        QSettings settings;
        settings.setValue("encoderCenterOffset", m_encoderCenterOffset);

        emit isCalibratedChanged(true);
        logError(QString("[CALIBRATION SUCCESS] Encoder offset: %1°").arg(m_encoderCenterOffset, 0, 'f', 3));
    });
}

void ApplicationController::clearErrorLog()
{
    m_errorLog.clear();
    emit errorLogChanged(m_errorLog);
}

void ApplicationController::onDevicePositionAck(int position)
{
    m_currentPosition = position;
    emit currentPositionChanged(position);
}

void ApplicationController::onDeviceAngleReceived(float angle)
{
    m_currentAngle = angle;
    emit currentAngleChanged(angle);

    if (m_sequencer->isRunning() && m_currentPosition == m_currentCommandedPosition) {
        checkError();
    }
}

void ApplicationController::onSequencerPosition(int position, float angle)
{
    m_currentCommandedPosition = position;
    m_currentCommandedAngle = angle;
    m_device->sendPosition(position);
}

void ApplicationController::checkError()
{
    if (!m_isCalibrated) return;

    float relativeAngle = m_currentAngle - m_encoderCenterOffset;
    while (relativeAngle > 180.0f) relativeAngle -= 360.0f;
    while (relativeAngle < -180.0f) relativeAngle += 360.0f;

    float servoAngle = qBound(-75.0f, relativeAngle, 75.0f);
    float error = qAbs(m_currentCommandedAngle - servoAngle);

    if (error > m_maxError) {
        m_maxError = error;
        emit maxErrorChanged(m_maxError);

        if (error > 1.0f && !m_servoFailed) {
            m_servoFailed = true;
            emit servoFailedChanged(true);
        }
    }

    QString log = QString("[%1] Pos:%2 Cmd:%3° Enc:%4° Mapped:%5° Error:%6°")
                      .arg(QDateTime::currentDateTime().toString("hh:mm:ss.zzz"))
                      .arg(m_currentCommandedPosition, 4)
                      .arg(QString::number(m_currentCommandedAngle, 'f', 3))
                      .arg(QString::number(m_currentAngle, 'f', 3))
                      .arg(QString::number(servoAngle, 'f', 3))
                      .arg(QString::number(error, 'f', 3));

    logError(log);
}

void ApplicationController::onDeviceError(const QString &error)
{
    emit errorOccurred(error);
}

void ApplicationController::resetErrorTracking()
{
    m_maxError = 0.0f;
    m_servoFailed = false;
    m_errorLog.clear();
    emit maxErrorChanged(m_maxError);
    emit servoFailedChanged(false);
    emit errorLogChanged(m_errorLog);
}

void ApplicationController::logError(const QString &message)
{
    m_errorLog.append(message + "\n");
    emit errorLogChanged(m_errorLog);
    qDebug() << message;
}

// MISSING IMPLEMENTATIONS (add these):
bool ApplicationController::deviceConnected() const
{
    return m_device->isConnected();
}

bool ApplicationController::sequenceRunning() const
{
    return m_sequencer->isRunning();
}
