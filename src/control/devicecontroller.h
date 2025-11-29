#ifndef DEVICECONTROLLER_H
#define DEVICECONTROLLER_H

#include <QObject>
#include <QTimer>
#include "../serial/SerialPortManager.h"

class DeviceController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ isConnected NOTIFY connectionChanged)
    Q_PROPERTY(float lastAngle READ lastAngle NOTIFY angleReceived)
    Q_PROPERTY(int lastPosition READ lastPosition NOTIFY positionAcknowledged)

public:
    explicit DeviceController(QObject *parent = nullptr);
    ~DeviceController();

    bool isConnected() const;
    float lastAngle() const { return m_lastAngle; }
    int lastPosition() const { return m_lastPosition; }

    Q_INVOKABLE bool connectDevice(const QString &portName);
    Q_INVOKABLE void disconnectDevice();
    Q_INVOKABLE void sendPosition(int position);
    Q_INVOKABLE void calibrate();

signals:
    void connectionChanged(bool connected);
    void positionAcknowledged(int position);
    void angleReceived(float angle);
    void errorOccurred(const QString &message);

private slots:
    void onDataReceived(const QByteArray &data);
    void onError(const QString &error);
    // void sendEncoderReadCommand();
    void processStateMachine();

private:
    enum State {
        IDLE,
        WAITING_SERVO_ACK,
        WAITING_ENCODER_RESPONSE
    };

    SerialPortManager *m_portManager;
    State m_state;
    int m_lastCommandedPosition;
    int m_lastPosition;
    float m_lastAngle;
    QTimer m_stateTimer;
};

#endif // DEVICECONTROLLER_H
