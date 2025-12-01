#ifndef DEVICECONTROLLER_H
#define DEVICECONTROLLER_H

#include <QObject>
#include <QString>
#include <QVector>

class SerialPortManager;

/**
 * @brief Controls servo motor and processes encoder feedback
 *
 * Responsibility: Manage device-specific command protocols,
 * parse encoder data, and maintain position state.
 * Follows Single Responsibility and Dependency Inversion Principles.
 */
class DeviceController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double currentEncoderAngle READ currentEncoderAngle NOTIFY encoderAngleChanged)
    Q_PROPERTY(int currentServoPosition READ currentServoPosition NOTIFY servoPositionChanged)
    Q_PROPERTY(double positionError READ positionError NOTIFY positionErrorChanged)

public:
    explicit DeviceController(SerialPortManager *serialPort, QObject *parent = nullptr);

    // Property accessors
    double currentEncoderAngle() const { return m_currentEncoderAngle; }
    int currentServoPosition() const { return m_currentServoPosition; }
    double positionError() const { return m_positionError; }

    // Device command methods
    Q_INVOKABLE bool sendServoCommand(int microseconds);
    Q_INVOKABLE bool requestEncoderReading();
    Q_INVOKABLE bool calibrateEncoder();
    Q_INVOKABLE void setServoToZero();

    // Position mapping
    double mapPulseToAngle(int pulse, int startPulse, int endPulse,
                           double startAngle, double endAngle) const;

signals:
    void encoderAngleChanged(double angle);
    void servoPositionChanged(int position);
    void positionErrorChanged(double error);
    void commandSent(const QString &command);
    void commandAcknowledged(const QString &response);
    void deviceError(const QString &errorMsg);

private slots:
    void handleSerialData(const QString &data);

private:
    void parseEncoderResponse(const QString &response);
    void calculatePositionError(int servoPulse, double encoderAngle);

    SerialPortManager *m_serialPort;
    double m_currentEncoderAngle;
    int m_currentServoPosition;
    double m_positionError;

    // Command protocol constants
    static constexpr const char* SERVO_CMD_PREFIX = "S";
    static constexpr const char* ENCODER_READ_CMD = "E0";
    static constexpr const char* ENCODER_ZERO_CMD = "E1";
    static constexpr int SERVO_ZERO_POSITION = 1500;
};

#endif // DEVICECONTROLLER_H
