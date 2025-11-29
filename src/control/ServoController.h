#ifndef SERVOCONTROLLER_H
#define SERVOCONTROLLER_H

#include <QObject>
#include "../interfaces/IDataTransmitter.h"

class ServoDevice;

/**
 * @class ServoController
 * @brief Manages servo positioning logic
 *
 * Handles servo command generation and position tracking.
 * Follows SRP by separating control logic from hardware comms.
 */
class ServoController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentPosition READ currentPosition NOTIFY positionChanged)
    Q_PROPERTY(bool isActive READ isActive NOTIFY activeChanged)

public:
    explicit ServoController(QObject *parent = nullptr);
    ~ServoController();

    /**
     * @brief Set servo device for communication
     * @param device Servo device instance
     */
    void setServoDevice(ServoDevice *device);

    /**
     * @brief Send position command to servo
     * @param position Position in microseconds (900-2250)
     * @return true if command sent
     */
    Q_INVOKABLE bool setPosition(int position);

    /**
     * @brief Get current commanded position
     * @return Current position
     */
    int currentPosition() const { return m_currentPosition; }

    /**
     * @brief Check if controller is active
     * @return Active status
     */
    bool isActive() const { return m_isActive; }

signals:
    void positionChanged(int position);
    void activeChanged(bool active);
    void errorOccurred(const QString &message);

public slots:
    void start();
    void stop();

private:
    ServoDevice *m_servoDevice;
    int m_currentPosition;
    bool m_isActive;

    void setActive(bool active);
};

#endif // SERVOCONTROLLER_H
