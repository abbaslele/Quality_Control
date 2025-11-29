#include "SerialPortManager.h"
#include <QDebug>

static constexpr int CONNECTION_TIMEOUT_MS = 5000;
static constexpr int CONNECTION_CHECK_INTERVAL_MS = 1000;

SerialPortManager::SerialPortManager(const QString &portName, QObject *parent)
    : QObject(parent)
    , m_serialPort(std::make_unique<QSerialPort>())
    , m_portName(portName)
    , m_isConnected(false)
{
    m_serialPort->setPortName(portName);
    setupConnectionMonitoring();

    connect(m_serialPort.get(), &QSerialPort::readyRead,
            this, &SerialPortManager::handleReadyRead);
    connect(m_serialPort.get(), &QSerialPort::errorOccurred,
            this, &SerialPortManager::handleError);
}

SerialPortManager::~SerialPortManager()
{
    closePort();
}

bool SerialPortManager::configurePort(qint32 baudRate,
                                      QSerialPort::DataBits dataBits,
                                      QSerialPort::Parity parity,
                                      QSerialPort::StopBits stopBits)
{
    if (m_serialPort->isOpen()) {
        m_lastError = QStringLiteral("Cannot configure open port");
        emit errorOccurred(m_lastError);
        return false;
    }

    m_serialPort->setBaudRate(baudRate);
    m_serialPort->setDataBits(dataBits);
    m_serialPort->setParity(parity);
    m_serialPort->setStopBits(stopBits);
    m_serialPort->setFlowControl(QSerialPort::NoFlowControl);

    return true;
}

bool SerialPortManager::openPort()
{
    if (m_serialPort->isOpen()) {
        return true;
    }

    if (m_serialPort->open(QIODevice::ReadWrite)) {
        m_isConnected = true;
        m_connectionMonitor.start(CONNECTION_CHECK_INTERVAL_MS);
        emit connectionChanged(true);
        qDebug() << "Serial port opened:" << m_portName;
        return true;
    } else {
        m_lastError = m_serialPort->errorString();
        emit errorOccurred(m_lastError);
        return false;
    }
}

void SerialPortManager::closePort()
{
    m_connectionMonitor.stop();
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
        m_isConnected = false;
        emit connectionChanged(false);
        qDebug() << "Serial port closed:" << m_portName;
    }
}

bool SerialPortManager::isOpen() const
{
    return m_serialPort->isOpen();
}

bool SerialPortManager::sendDataAsync(const QByteArray &data)
{
    if (!m_serialPort->isOpen()) {
        m_lastError = QStringLiteral("Port not open");
        emit errorOccurred(m_lastError);
        return false;
    }

    qint64 bytesWritten = m_serialPort->write(data);
    if (bytesWritten == -1) {
        m_lastError = m_serialPort->errorString();
        emit errorOccurred(m_lastError);
        return false;
    }

    return m_serialPort->flush();
}

QString SerialPortManager::lastError() const
{
    return m_lastError;
}

void SerialPortManager::handleReadyRead()
{
    const QByteArray data = m_serialPort->readAll();
    if (!data.isEmpty()) {
        emit dataReceived(data);
    }
}

void SerialPortManager::handleError(QSerialPort::SerialPortError error)
{
    if (error != QSerialPort::NoError) {
        m_lastError = m_serialPort->errorString();
        emit errorOccurred(m_lastError);

        if (error == QSerialPort::ResourceError) {
            closePort();
        }
    }
}

void SerialPortManager::setupConnectionMonitoring()
{
    connect(&m_connectionMonitor, &QTimer::timeout,
            this, [this]() {
                // Simple keepalive - check if port is still responsive
                if (m_serialPort->isOpen()) {
                    m_serialPort->clearError();
                }
            });
    m_connectionMonitor.setInterval(CONNECTION_CHECK_INTERVAL_MS);
}

void SerialPortManager::handleConnectionTimeout()
{
    // Implement timeout logic if needed
}
