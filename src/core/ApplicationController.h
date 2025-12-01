#ifndef APPLICATIONCONTROLLER_H
#define APPLICATIONCONTROLLER_H

#include <QObject>
#include <QSettings>
#include <QVector>
#include <QPair>

class SerialPortManager;
class DeviceController;
class PositionSequencer;

/**
 * @brief Application-level coordinator and facade
 *
 * Responsibility: Coordinate between components, manage application state,
 * handle settings persistence, and provide unified interface to QML.
 * Follows Dependency Inversion and Interface Segregation Principles.
 */
class ApplicationController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isCalibrated READ isCalibrated NOTIFY calibrationChanged)
    Q_PROPERTY(int startPulse READ startPulse WRITE setStartPulse NOTIFY startPulseChanged)
    Q_PROPERTY(int endPulse READ endPulse WRITE setEndPulse NOTIFY endPulseChanged)
    Q_PROPERTY(double startAngle READ startAngle WRITE setStartAngle NOTIFY startAngleChanged)
    Q_PROPERTY(double endAngle READ endAngle WRITE setEndAngle NOTIFY endAngleChanged)
    Q_PROPERTY(int steps READ steps WRITE setSteps NOTIFY stepsChanged)

public:
    explicit ApplicationController(QObject *parent = nullptr);
    ~ApplicationController() override;

    // Component accessors for QML
    Q_INVOKABLE QObject* serialPort() const;
    Q_INVOKABLE QObject* deviceController() const;
    Q_INVOKABLE QObject* positionSequencer() const;

    // Property accessors
    bool isCalibrated() const { return m_isCalibrated; }
    int startPulse() const { return m_startPulse; }
    int endPulse() const { return m_endPulse; }
    double startAngle() const { return m_startAngle; }
    double endAngle() const { return m_endAngle; }
    int steps() const { return m_steps; }

    void setStartPulse(int pulse);
    void setEndPulse(int pulse);
    void setStartAngle(double angle);
    void setEndAngle(double angle);
    void setSteps(int steps);

    // High-level operations
    Q_INVOKABLE void performCalibration();
    Q_INVOKABLE void startTest();
    Q_INVOKABLE void stopTest();
    Q_INVOKABLE QVector<double> calculateRealPositions() const;
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE void loadSettings();

signals:
    void calibrationChanged(bool calibrated);
    void startPulseChanged(int pulse);
    void endPulseChanged(int pulse);
    void startAngleChanged(double angle);
    void endAngleChanged(double angle);
    void stepsChanged(int steps);
    void testDataPoint(int pulse, double expectedAngle, double actualAngle, double error);
    void statusMessage(const QString &message);

private slots:
    void handlePositionCommand(int position, int index);
    void handleEncoderUpdate(double angle);
    void handleSequenceComplete();

private:
    void initializeComponents();
    void connectSignals();
    double interpolateAngle(int pulse) const;

    SerialPortManager *m_serialPort;
    DeviceController *m_deviceController;
    PositionSequencer *m_positionSequencer;
    QSettings *m_settings;

    bool m_isCalibrated;
    int m_startPulse;
    int m_endPulse;
    double m_startAngle;
    double m_endAngle;
    int m_steps;

    QVector<QPair<int, double>> m_testResults;

    // Default configuration constants
    static constexpr int DEFAULT_START_PULSE = 900;
    static constexpr int DEFAULT_END_PULSE = 2250;
    static constexpr double DEFAULT_START_ANGLE = -60.0;
    static constexpr double DEFAULT_END_ANGLE = 60.0;
    static constexpr int DEFAULT_STEPS = 9;
    static constexpr int DEFAULT_BAUD_RATE = 19200;
};

#endif // APPLICATIONCONTROLLER_H
