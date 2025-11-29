// ApplicationController.h
#ifndef APPLICATIONCONTROLLER_H
#define APPLICATIONCONTROLLER_H

#include <QObject>
#include <QString>
#include "src/control/DeviceController.h"
#include "src/control/PositionSequencer.h"

class ApplicationController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool deviceConnected READ deviceConnected NOTIFY deviceConnectionChanged)
    Q_PROPERTY(bool sequenceRunning READ sequenceRunning NOTIFY sequenceRunningChanged)
    Q_PROPERTY(int currentPosition READ currentPosition NOTIFY currentPositionChanged)
    Q_PROPERTY(float currentAngle READ currentAngle NOTIFY currentAngleChanged)
    Q_PROPERTY(float maxError READ maxError NOTIFY maxErrorChanged)
    Q_PROPERTY(bool servoFailed READ servoFailed NOTIFY servoFailedChanged)
    Q_PROPERTY(QString errorLog READ errorLog NOTIFY errorLogChanged)
    Q_PROPERTY(bool isCalibrated READ isCalibrated NOTIFY isCalibratedChanged)
    Q_PROPERTY(float encoderCenterOffset READ encoderCenterOffset NOTIFY isCalibratedChanged)

public:
    explicit ApplicationController(QObject *parent = nullptr);
    ~ApplicationController();

    Q_INVOKABLE QStringList availablePorts() const;
    Q_INVOKABLE void connectDevice(const QString &portName);
    Q_INVOKABLE void disconnectDevice();
    Q_INVOKABLE void startSequence();
    Q_INVOKABLE void stopSequence();
    Q_INVOKABLE void calibrateDevice();
    Q_INVOKABLE void clearErrorLog();

    bool deviceConnected() const;
    bool sequenceRunning() const;
    int currentPosition() const { return m_currentPosition; }
    float currentAngle() const { return m_currentAngle; }
    float maxError() const { return m_maxError; }
    bool servoFailed() const { return m_servoFailed; }
    QString errorLog() const { return m_errorLog; }
    bool isCalibrated() const { return m_isCalibrated; }
    float encoderCenterOffset() const { return m_encoderCenterOffset; }

signals:
    void deviceConnectionChanged(bool connected);
    void sequenceRunningChanged(bool running);
    void currentPositionChanged(int position);
    void currentAngleChanged(float angle);
    void maxErrorChanged(float error);
    void servoFailedChanged(bool failed);
    void errorLogChanged(const QString &log);
    void isCalibratedChanged(bool calibrated);
    void errorOccurred(const QString &message);

private slots:
    void onDevicePositionAck(int position);
    void onDeviceAngleReceived(float angle);
    void onSequencerPosition(int position, float angle);
    void checkError();
    void onDeviceError(const QString &error);

private:
    DeviceController *m_device;
    PositionSequencer *m_sequencer;

    // State tracking
    float m_encoderCenterOffset;
    bool m_isCalibrated;
    int m_currentCommandedPosition;
    float m_currentCommandedAngle;
    int m_currentPosition;
    float m_currentAngle;
    float m_maxError;
    bool m_servoFailed;
    QString m_errorLog;

    void resetErrorTracking();
    void logError(const QString &message);
};

#endif // APPLICATIONCONTROLLER_H
