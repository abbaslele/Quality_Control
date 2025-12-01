#include "SerialPortManager.h"
#include <QDebug>

SerialPortManager::SerialPortManager(QObject *parent)
    : QObject(parent)
    , m_serialPort(new QSerialPort(this))
    , m_portName("")
    , m_baudRate(19200)
    , m_isConnected(false)
{
    connect(m_serialPort, &QSerialPort::readyRead,
            this, &SerialPortManager::handleReadyRead);
    connect(m_serialPort, &QSerialPort::errorOccurred,
            this, &SerialPortManager::handleError);
}

SerialPortManager::~SerialPortManager()
{
    closePort();
}

void SerialPortManager::setPortName(const QString &portName)
{
    if (m_portName != portName) {
        m_portName = portName;
        emit portNameChanged();
    }
}

void SerialPortManager::setBaudRate(int baudRate)
{
    if (m_baudRate != baudRate) {
        m_baudRate = baudRate;
        emit baudRateChanged();
    }
}

QStringList SerialPortManager::availablePorts() const
{
    QStringList portNames;
    const auto ports = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : ports) {
        portNames << info.portName();
    }
    return portNames;
}

bool SerialPortManager::openPort()
{
    if (m_isConnected) {
        closePort();
    }

    if (m_portName.isEmpty()) {
        emit errorOccurred("Port name not set");
        return false;
    }

    m_serialPort->setPortName(m_portName);
    m_serialPort->setBaudRate(m_baudRate);
    m_serialPort->setDataBits(DATA_BITS);
    m_serialPort->setParity(PARITY);
    m_serialPort->setStopBits(STOP_BITS);
    m_serialPort->setFlowControl(FLOW_CONTROL);

    if (m_serialPort->open(QIODevice::ReadWrite)) {
        updateConnectionStatus(true);
        qDebug() << "Serial port opened:" << m_portName << "at" << m_baudRate;
        return true;
    } else {
        QString errorMsg = QString("Failed to open port %1: %2")
        .arg(m_portName, m_serialPort->errorString());
        emit errorOccurred(errorMsg);
        qWarning() << errorMsg;
        return false;
    }
}

void SerialPortManager::closePort()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
        updateConnectionStatus(false);
        qDebug() << "Serial port closed:" << m_portName;
    }
}

bool SerialPortManager::writeData(const QString &data)
{
    if (!m_isConnected) {
        emit errorOccurred("Port not connected");
        return false;
    }

    QString dataWithNewline = data + "\n";
    qint64 bytesWritten = m_serialPort->write(dataWithNewline.toUtf8());

    if (bytesWritten == -1) {
        emit errorOccurred("Failed to write data to port");
        return false;
    }

    m_serialPort->flush();
    qDebug() << "Data written:" << data;
    return true;
}

void SerialPortManager::requestRead()
{
    // Trigger read if data is available
    if (m_serialPort->bytesAvailable() > 0) {
        handleReadyRead();
    }
}

void SerialPortManager::handleReadyRead()
{
    m_readBuffer.append(m_serialPort->readAll());

    // Process complete lines (terminated with \n)
    while (m_readBuffer.contains('\n')) {
        int newlineIndex = m_readBuffer.indexOf('\n');
        QByteArray line = m_readBuffer.left(newlineIndex);
        m_readBuffer.remove(0, newlineIndex + 1);

        QString receivedData = QString::fromUtf8(line).trimmed();
        if (!receivedData.isEmpty()) {
            qDebug() << "Data received:" << receivedData;
            emit dataReceived(receivedData);
        }
    }
}

void SerialPortManager::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::NoError) {
        return;
    }

    QString errorMsg = QString("Serial port error: %1").arg(m_serialPort->errorString());
    emit errorOccurred(errorMsg);
    qWarning() << errorMsg;

    // Close port on critical errors
    if (error == QSerialPort::ResourceError || error == QSerialPort::PermissionError) {
        closePort();
    }
}

void SerialPortManager::updateConnectionStatus(bool connected)
{
    if (m_isConnected != connected) {
        m_isConnected = connected;
        emit connectionChanged(connected);
    }
}
