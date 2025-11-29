#ifndef ENCODERDEVICE_H
#define ENCODERDEVICE_H

#include <QObject>
#include "../interfaces/ISerialDevice.h"
#include "../interfaces/IDataTransmitter.h"
#include "../interfaces/IDataReceiver.h"
#include "SerialPortManager.h"

/**
 * @class EncoderDevice
 * @brief Encoder serial device implementation
 *
 * Handles encoder-specific communication including
 * position query commands and response parsing.
 */
class EncoderDevice : public ISerialDevice,
                      public IDataTransmitter,
                      public IDataReceiver
{
    Q_OBJECT
    Q_INTERFACES(IDataTransmitter IDataReceiver)  // List non-QObject interfaces


public:
    explicit EncoderDevice(const QString &portName, QObject *parent = nullptr);
    ~EncoderDevice() override;

    // ISerialDevice interface
    QString deviceName() const override;
    bool isConnected() const override;

    // IDataTransmitter interface
    bool sendDataAsync(const QByteArray &data) override;

    // IDataReceiver interface
    void onDataReceived(const QByteArray &data) override;

    Q_INVOKABLE bool sendEncoderArm();    // E1
    Q_INVOKABLE bool sendEncoderRead();   // E0

    /**
     * @brief Request encoder position
     * @return true if request sent
     */
    bool requestPosition();

public slots:
    bool connectDevice();
    void disconnectDevice();

signals:
    /**
     * @brief Emitted when position data received
     * @param angle Angle in degrees (3 decimal precision)
     */
    void positionReceived(float angle);

    /**
     * @brief Emitted when encoder is ready
     */
    void encoderReady();

private slots:
    void handlePortData(const QByteArray &data);
    void handleError(const QString &error);


private:
    SerialPortManager *m_portManager;
    QByteArray m_receiveBuffer;

    void processReceiveBuffer();
};

#endif // ENCODERDEVICE_H
