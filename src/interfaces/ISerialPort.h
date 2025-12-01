#ifndef ISERIALPORT_H
#define ISERIALPORT_H

#include <QObject>
#include <QByteArray>
#include <functional>

/**
 * @brief Abstract interface for serial port communication
 * @details Implements Dependency Inversion Principle - high-level modules
 * depend on this abstraction, not concrete implementations.
 */
class ISerialPort : public QObject {
    Q_OBJECT

public:
    using DataCallback = std::function<void(const QByteArray&)>;

    explicit ISerialPort(QObject* parent = nullptr) : QObject(parent) {}
    virtual ~ISerialPort() = default;

    /**
     * @brief Open serial port with configuration
     * @param portName Device name (e.g., "COM3", "/dev/ttyUSB0")
     * @param baudRate Baud rate (e.g., 19200)
     * @return true if successful
     */
    virtual bool open(const QString& portName, qint32 baudRate) = 0;

    /** @brief Close serial port */
    virtual void close() = 0;

    /** @brief Check if port is open */
    virtual bool isOpen() const = 0;

    /** @brief Write data to serial port */
    virtual qint64 write(const QByteArray& data) = 0;

    /** @brief Get human-readable error string */
    virtual QString errorString() const = 0;

signals:
    /** @brief Emitted when data is received */
    void dataReceived(const QByteArray& data);

    /** @brief Emitted when error occurs */
    void errorOccurred(const QString& error);

    /** @brief Emitted when connection status changes */
    void connectionChanged(bool connected);
};

#endif // ISERIALPORT_H
