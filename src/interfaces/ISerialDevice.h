#ifndef ISERIALDEVICE_H
#define ISERIALDEVICE_H

#include <QString>
#include <QObject>

/**
 * @interface ISerialDevice
 * @brief Abstract interface for serial device communication
 *
 * Defines the contract for all serial devices in the system.
 * Implements ISP (Interface Segregation Principle) by providing
 * focused interfaces for different operations.
 */
class ISerialDevice : public QObject
{
    Q_OBJECT

public:
    explicit ISerialDevice(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~ISerialDevice() = default;

    /**
     * @brief Get the device name for display
     * @return Human-readable device name
     */
    virtual QString deviceName() const = 0;

    /**
     * @brief Check if device is currently connected
     * @return Connection status
     */
    virtual bool isConnected() const = 0;

signals:
    /**
     * @brief Emitted when connection status changes
     * @param connected New connection status
     */
    void connectionChanged(bool connected);

    /**
     * @brief Emitted when an error occurs
     * @param errorMessage Error description
     */
    void errorOccurred(const QString &errorMessage);
};

// Declare interface for Qt's meta-object system
Q_DECLARE_INTERFACE(ISerialDevice, "com.qualitycontrol.ISerialDevice")

#endif // ISERIALDEVICE_H
