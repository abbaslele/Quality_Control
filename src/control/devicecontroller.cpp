#include "DeviceController.h"
#include <QDebug>
#include <QTimer>

DeviceController::DeviceController(QObject *parent)
    : QObject(parent)
    , m_portManager(new SerialPortManager("", this))
    , m_state(IDLE)
    , m_lastCommandedPosition(0)
    , m_lastPosition(0)
    , m_lastAngle(0.0f)
{
    connect(m_portManager, &SerialPortManager::dataReceived,
            this, &DeviceController::onDataReceived);
    connect(m_portManager, &SerialPortManager::errorOccurred,
            this, &DeviceController::onError);

    m_stateTimer.setSingleShot(true);
    connect(&m_stateTimer, &QTimer::timeout,
            this, [this]() { processStateMachine(); });
}

DeviceController::~DeviceController()
{
    disconnectDevice();
}

bool DeviceController::isConnected() const
{
    return m_portManager->isOpen();
}

bool DeviceController::connectDevice(const QString &portName)
{
    if (m_portManager->isOpen()) {
        disconnectDevice();
    }

    m_portManager = new SerialPortManager(portName, this);
    connect(m_portManager, &SerialPortManager::dataReceived,
            this, &DeviceController::onDataReceived);
    connect(m_portManager, &SerialPortManager::errorOccurred,
            this, &DeviceController::onError);

    if (!m_portManager->configurePort()) {
        return false;
    }

    bool success = m_portManager->openPort();
    if (success) {
        emit connectionChanged(true);
    }
    return success;
}

void DeviceController::disconnectDevice()
{
    if (m_portManager->isOpen()) {
        m_portManager->closePort();
        emit connectionChanged(false);
    }
}

void DeviceController::sendPosition(int position)
{
    if (position < 900 || position > 2100) {
        emit errorOccurred(QString("Position out of range [900-2100]: %1").arg(position));
        return;
    }

    m_lastCommandedPosition = position;

    QByteArray command = QString("S%1\n").arg(position).toUtf8();
    if (m_portManager->sendDataAsync(command)) {
        m_state = WAITING_SERVO_ACK;
        m_stateTimer.start(200); // Wait for ACK
    } else {
        emit errorOccurred("Failed to send servo command");
    }
}

void DeviceController::calibrate()
{
    if (!m_portManager->isOpen()) {
        emit errorOccurred("Device not connected");
        return;
    }

    // Send center position
    sendPosition(1500);

    // After servo moves, zero encoder
    QTimer::singleShot(1500, [this]() {
        m_portManager->sendDataAsync("E1\n");
        emit errorOccurred("Calibration: Encoder zeroed at center");
    });
}

void DeviceController::onDataReceived(const QByteArray &data)
{
    QString response = QString::fromUtf8(data).trimmed();

    if (response.startsWith("ACK:")) {
        int pos = response.mid(4).toInt();
        m_lastPosition = pos;
        emit positionAcknowledged(pos);

        m_state = WAITING_ENCODER_RESPONSE;
        m_stateTimer.start(500); // Wait 500ms for servo to settle
    }
    else if (response.startsWith("ERR:")) {
        emit errorOccurred(response);
        m_state = IDLE;
    }
    else {
        bool ok;
        float angle = response.toFloat(&ok);
        if (ok) {
            m_lastAngle = angle;
            emit angleReceived(angle);
        } else {
            emit errorOccurred(QString("Invalid response: %1").arg(response));
        }
        m_state = IDLE;
    }
}

void DeviceController::onError(const QString &error)
{
    emit errorOccurred(error);
    m_state = IDLE;
}

void DeviceController::processStateMachine()
{
    switch (m_state) {
    case WAITING_SERVO_ACK:
        emit errorOccurred("Timeout waiting for servo ACK");
        m_state = IDLE;
        break;

    case WAITING_ENCODER_RESPONSE:
        m_portManager->sendDataAsync("E0\n");
        m_stateTimer.start(200);
        break;

    case IDLE:
        break;
    }
}
