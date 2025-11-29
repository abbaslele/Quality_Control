#ifndef SERVODEVICE_H
#define SERVODEVICE_H

#include "../interfaces/ISerialDevice.h"
#include "../interfaces/IDataTransmitter.h"
#include "SerialPortManager.h"

/**
 * @class ServoDevice
 * @brief Servo motor serial device implementation
 *
 * Encapsulates servo-specific communication logic.
 * Implements DIP by depending on abstractions.
 */
class ServoDevice : public ISerialDevice, public IDataTransmitter
{
    Q_OBJECT
    Q_INTERFACES(IDataTransmitter)

public:
    explicit ServoDevice(const QString &portName, QObject *parent = nullptr);
    ~ServoDevice() override;

    // ISerialDevice interface
    QString deviceName() const override;
    bool isConnected() const override;

    // IDataTransmitter interface
    bool sendDataAsync(const QByteArray &data) override;

    /**
     * @brief Send servo position command
     * @param position Position in microseconds (900-2250)
     * @return true if command sent successfully
     */
    bool sendPositionCommand(int position);

public slots:
    bool connectDevice();
    void disconnectDevice();

private slots:
    void handleError(const QString &error);

private:
    SerialPortManager *m_portManager;
};

#endif // SERVODEVICE_H
