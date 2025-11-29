#ifndef IDATATRANSMITTER_H
#define IDATATRANSMITTER_H

#include <QByteArray>

/**
 * @interface IDataTransmitter
 * @brief Interface for devices that can transmit data
 *
 * Provides contract for sending data through serial connection.
 * Follows ISP by separating transmission from reception concerns.
 */
class IDataTransmitter
{
public:
    virtual ~IDataTransmitter() = default;

    /**
     * @brief Send data asynchronously
     * @param data Data to transmit
     * @return true if data queued successfully
     */
    virtual bool sendDataAsync(const QByteArray &data) = 0;
};

// IMPORTANT: Declare interface for Qt's meta-object system
Q_DECLARE_INTERFACE(IDataTransmitter, "com.qualitycontrol.IDataTransmitter")

#endif // IDATATRANSMITTER_H
