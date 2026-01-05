#ifndef BACKLASH_TESTER_H
#define BACKLASH_TESTER_H

#include <QObject>
#include <QTimer>
#include <QVector>

class DeviceController;

class BacklashTester : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int countdown READ countdown NOTIFY countdownChanged)
    Q_PROPERTY(double maxAngleForward READ maxAngleForward NOTIFY maxAngleForwardChanged)
    Q_PROPERTY(double maxAngleReverse READ maxAngleReverse NOTIFY maxAngleReverseChanged)
    Q_PROPERTY(double avgAngleForward READ avgAngleForward NOTIFY avgAngleForwardChanged)
    Q_PROPERTY(double avgAngleReverse READ avgAngleReverse NOTIFY avgAngleReverseChanged)
    Q_PROPERTY(double backlashValueMax READ backlashValueMax NOTIFY backlashValueMaxChanged)
    Q_PROPERTY(double backlashValueAvg READ backlashValueAvg NOTIFY backlashValueAvgChanged)
    Q_PROPERTY(QString backlashColorMax READ backlashColorMax NOTIFY backlashColorMaxChanged)
    Q_PROPERTY(QString backlashColorAvg READ backlashColorAvg NOTIFY backlashColorAvgChanged)
    Q_PROPERTY(int forwardSampleCount READ forwardSampleCount NOTIFY forwardSampleCountChanged)
    Q_PROPERTY(int reverseSampleCount READ reverseSampleCount NOTIFY reverseSampleCountChanged)

public:
    explicit BacklashTester(DeviceController *deviceCtrl, QObject *parent = nullptr);

    bool isRunning() const { return m_isRunning; }
    int countdown() const { return m_countdown; }
    double maxAngleForward() const { return m_maxAngleForward; }
    double maxAngleReverse() const { return m_maxAngleReverse; }
    double avgAngleForward() const { return m_avgAngleForward; }
    double avgAngleReverse() const { return m_avgAngleReverse; }
    double backlashValueMax() const { return m_backlashValueMax; }
    double backlashValueAvg() const { return m_backlashValueAvg; }
    QString backlashColorMax() const { return m_backlashColorMax; }
    QString backlashColorAvg() const { return m_backlashColorAvg; }
    int forwardSampleCount() const { return m_forwardSamples.size(); }
    int reverseSampleCount() const { return m_reverseSamples.size(); }

    Q_INVOKABLE void startTest();
    Q_INVOKABLE void stopTest();
    Q_INVOKABLE void resetValues();

signals:
    void runningChanged(bool running);
    void countdownChanged(int seconds);
    void maxAngleForwardChanged(double angle);
    void maxAngleReverseChanged(double angle);
    void avgAngleForwardChanged(double angle);
    void avgAngleReverseChanged(double angle);
    void backlashValueMaxChanged(double value);
    void backlashValueAvgChanged(double value);
    void backlashColorMaxChanged(QString color);
    void backlashColorAvgChanged(QString color);
    void forwardSampleCountChanged(int count);
    void reverseSampleCountChanged(int count);
    void testCompleted();
    void statusMessage(const QString &message);

private slots:
    void onCountdownTick();
    void onEncoderAngleChanged(double angle);
    void onPhaseComplete();

private:
    void startForwardPhase();
    void startReversePhase();
    void calculateBacklash();
    void updateBacklashColors();
    double calculateAverage(const QVector<double> &samples) const;

    DeviceController *m_deviceController;
    QTimer *m_countdownTimer;
    QTimer *m_readTimer;

    bool m_isRunning;
    int m_countdown;

    // Maximum values
    double m_maxAngleForward;
    double m_maxAngleReverse;

    // Average values
    double m_avgAngleForward;
    double m_avgAngleReverse;

    // Backlash values
    double m_backlashValueMax;
    double m_backlashValueAvg;

    // Color indicators
    QString m_backlashColorMax;
    QString m_backlashColorAvg;

    // Sample storage
    QVector<double> m_forwardSamples;
    QVector<double> m_reverseSamples;

    enum TestPhase {
        Idle,
        ForwardPhase,
        ReversePhase
    };
    TestPhase m_currentPhase;

    static constexpr int TEST_DURATION = 5; // 3 seconds per phase
    static constexpr int READ_INTERVAL = 100; // Read encoder every 100ms
    static constexpr double BACKLASH_THRESHOLD = 0.3; // Threshold for color change
    static constexpr double MAX_VALID_ANGLE = 2.5; // Maximum valid angle reading (degrees)
};

#endif // BACKLASH_TESTER_H
