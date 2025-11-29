#include "EncoderDevice.h"
#include <QDebug>
#include <QRegularExpression>

static constexpr char POSITION_COMMAND = '0';
static constexpr char READY_COMMAND = '1';

EncoderDevice::EncoderDevice(const QString &portName, QObject *parent)
    : ISerialDevice(parent)
    , m_portManager(new SerialPortManager(portName, this))
{
    connect(m_portManager, &SerialPortManager::dataReceived,
            this, &EncoderDevice::handlePortData);
    connect(m_portManager, &SerialPortManager::errorOccurred,
            this, &EncoderDevice::handleError);
    connect(m_portManager, &SerialPortManager::connectionChanged,
            this, &EncoderDevice::connectionChanged);
}

EncoderDevice::~EncoderDevice()
{
    disconnectDevice();
}

QString EncoderDevice::deviceName() const
{
    return QStringLiteral("Position Encoder");
}

bool EncoderDevice::isConnected() const
{
    return m_portManager->isOpen();
}

bool EncoderDevice::sendDataAsync(const QByteArray &data)
{
    return m_portManager->sendDataAsync(data);
}

bool EncoderDevice::requestPosition()
{
    // Protocol: send "0\n" to request position
    QByteArray command(1, POSITION_COMMAND);
    command.append('\n');
    return sendDataAsync(command);
}

void EncoderDevice::onDataReceived(const QByteArray &data)
{
    handlePortData(data);
}

void EncoderDevice::handlePortData(const QByteArray &data)
{
    m_receiveBuffer.append(data);
    processReceiveBuffer();
}

void EncoderDevice::processReceiveBuffer()
{
    // Process complete lines
    while (m_receiveBuffer.contains('\n')) {
        int newlinePos = m_receiveBuffer.indexOf('\n');
        QByteArray line = m_receiveBuffer.left(newlinePos).trimmed();
        m_receiveBuffer.remove(0, newlinePos + 1);

        if (line.isEmpty()) {
            continue;
        }

        // Check for ready response
        if (line == "Encoder is ready!") {
            emit encoderReady();
            continue;
        }

        // Parse angle value (format: "123.456")
        bool ok = false;
        float angle = line.toFloat(&ok);
        if (ok) {
            emit positionReceived(angle);
        } else {
            qWarning() << "Failed to parse encoder data:" << line;
        }
    }
}

bool EncoderDevice::connectDevice()
{
    if (!m_portManager->configurePort(19200)) {
        return false;
    }
    return m_portManager->openPort();
}

void EncoderDevice::disconnectDevice()
{
    m_portManager->closePort();
}

void EncoderDevice::handleError(const QString &error)
{
    emit errorOccurred(error);
}

bool EncoderDevice::sendEncoderArm()
{
    if (!m_portManager || !m_portManager->isOpen())
        return false;
    return m_portManager->writeData("E1\n");
}

bool EncoderDevice::sendEncoderRead()
{
    if (!m_portManager || !m_portManager->isOpen())
        return false;
    return m_portManager->m_portManager->write("E0\n");
}
