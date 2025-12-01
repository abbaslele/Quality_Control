#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QString>
#include <QStringList>
#include <QTimer>

/**
 * @brief Manages low-level serial port communication
 *
 * Responsibility: Handle serial port operations including opening,
 * closing, reading, writing, and port enumeration.
 * Follows Single Responsibility Principle.
 */
class SerialPortManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionChanged)
    Q_PROPERTY(QString portName READ portName WRITE setPortName NOTIFY portNameChanged)
    Q_PROPERTY(int baudRate READ baudRate WRITE setBaudRate NOTIFY baudRateChanged)

public:
    explicit SerialPortManager(QObject *parent = nullptr);
    ~SerialPortManager() override;

    // Property accessors
    bool isConnected() const { return m_isConnected; }
    QString portName() const { return m_portName; }
    int baudRate() const { return m_baudRate; }

    void setPortName(const QString &portName);
    void setBaudRate(int baudRate);

    // Invokable methods for QML
    Q_INVOKABLE QStringList availablePorts() const;
    Q_INVOKABLE bool openPort();
    Q_INVOKABLE void closePort();
    Q_INVOKABLE bool writeData(const QString &data);
    Q_INVOKABLE void requestRead();

signals:
    void connectionChanged(bool connected);
    void portNameChanged();
    void baudRateChanged();
    void dataReceived(const QString &data);
    void errorOccurred(const QString &errorMsg);

private slots:
    void handleReadyRead();
    void handleError(QSerialPort::SerialPortError error);

private:
    void updateConnectionStatus(bool connected);

    QSerialPort *m_serialPort;
    QString m_portName;
    int m_baudRate;
    bool m_isConnected;
    QByteArray m_readBuffer;

    // Serial port configuration constants
    static constexpr QSerialPort::DataBits DATA_BITS = QSerialPort::Data8;
    static constexpr QSerialPort::Parity PARITY = QSerialPort::NoParity;
    static constexpr QSerialPort::StopBits STOP_BITS = QSerialPort::OneStop;
    static constexpr QSerialPort::FlowControl FLOW_CONTROL = QSerialPort::NoFlowControl;
};

#endif // SERIALPORTMANAGER_H
