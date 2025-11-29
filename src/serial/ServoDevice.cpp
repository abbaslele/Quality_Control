#include "ServoDevice.h"
#include <QDebug>

namespace {
const char *SERVO_CMD_PREFIX = "S";
const char *SERVO_CMD_SUFFIX = "\n";
}

ServoDevice::ServoDevice(const QString &portName, QObject *parent)
    : ISerialDevice(parent)
    , m_portManager(new SerialPortManager(portName, this))
{
    connect(m_portManager, &SerialPortManager::errorOccurred,
            this, &ServoDevice::handleError);
    connect(m_portManager, &SerialPortManager::connectionChanged,
            this, &ServoDevice::connectionChanged);
}

ServoDevice::~ServoDevice()
{
    disconnectDevice();
}

QString ServoDevice::deviceName() const
{
    return QStringLiteral("Servo Motor");
}

bool ServoDevice::isConnected() const
{
    return m_portManager->isOpen();
}

bool ServoDevice::sendDataAsync(const QByteArray &data)
{
    return m_portManager->sendDataAsync(data);
}

bool ServoDevice::sendPositionCommand(int position)
{
    // Protocol: send integer as string followed by newline
    QByteArray command = QByteArray::number(position) + '\n';
    qDebug() << "Sending servo command:" << command.trimmed();
    return sendDataAsync("S" + command);
}

bool ServoDevice::connectDevice()
{
    if (!m_portManager->configurePort(19200)) {
        return false;
    }
    return m_portManager->openPort();
}

void ServoDevice::disconnectDevice()
{
    m_portManager->closePort();
}

void ServoDevice::handleError(const QString &error)
{
    emit errorOccurred(error);
}
