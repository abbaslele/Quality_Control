#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <memory>
#include <QTimer>

/**
 * @class SerialPortManager
 * @brief Manages low-level serial port operations
 *
 * Handles serial port configuration, connection management,
 * and asynchronous I/O operations. Implements SRP by focusing
 * solely on serial communication concerns.
 */
class SerialPortManager : public QObject
{
    Q_OBJECT

public:
    explicit SerialPortManager(const QString &portName,
                               QObject *parent = nullptr);
    ~SerialPortManager();

    /**
     * @brief Configure serial port parameters
     * @param baudRate Baud rate (default: 19200)
     * @param dataBits Data bits (default: 8)
     * @param parity Parity (default: NoParity)
     * @param stopBits Stop bits (default: OneStop)
     * @return true if configuration successful
     */
    bool configurePort(qint32 baudRate = 19200,
                       QSerialPort::DataBits dataBits = QSerialPort::Data8,
                       QSerialPort::Parity parity = QSerialPort::NoParity,
                       QSerialPort::StopBits stopBits = QSerialPort::OneStop);

    /**
     * @brief Open serial port connection
     * @return true if port opened successfully
     */
    bool openPort();

    /**
     * @brief Close serial port connection
     */
    void closePort();

    /**
     * @brief Check if port is open
     * @return Connection status
     */
    bool isOpen() const;

    /**
     * @brief Send data asynchronously
     * @param data Data to transmit
     * @return true if data queued successfully
     */
    bool sendDataAsync(const QByteArray &data);

    /**
     * @brief Get last occurred error
     * @return Error string
     */
    QString lastError() const;

signals:
    void dataReceived(const QByteArray &data);
    void connectionChanged(bool connected);
    void errorOccurred(const QString &error);

private slots:
    void handleReadyRead();
    void handleError(QSerialPort::SerialPortError error);
    void handleConnectionTimeout();

private:
    std::unique_ptr<QSerialPort> m_serialPort;
    QString m_portName;
    QString m_lastError;
    QTimer m_connectionMonitor;
    bool m_isConnected;

    void setupConnectionMonitoring();
};

#endif // SERIALPORTMANAGER_H
