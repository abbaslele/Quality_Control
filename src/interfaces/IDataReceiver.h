#ifndef IDATARECEIVER_H
#define IDATARECEIVER_H

#include <QByteArray>

/**
 * @interface IDataReceiver
 * @brief Interface for devices that can receive data
 *
 * Provides contract for receiving data from serial connection.
 * Enables flexible data reception strategies.
 */
class IDataReceiver
{
public:
    virtual ~IDataReceiver() = default;

    /**
     * @brief Process received data
     * @param data Received data buffer
     */
    virtual void onDataReceived(const QByteArray &data) = 0;
};

// IMPORTANT: Declare interface for Qt's meta-object system
Q_DECLARE_INTERFACE(IDataReceiver, "com.qualitycontrol.IDataReceiver")

#endif // IDATARECEIVER_H
