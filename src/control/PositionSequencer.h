#ifndef POSITIONSEQUENCER_H
#define POSITIONSEQUENCER_H

#include <QObject>
#include <QTimer>
#include <QVector>

/**
 * @brief Manages test sequence execution and timing
 *
 * Responsibility: Execute position sequences with configurable timing,
 * handle forward/backward motion, and loop control.
 * Follows Single Responsibility and Open/Closed Principles.
 */
class PositionSequencer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY runningStateChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(bool loopEnabled READ loopEnabled WRITE setLoopEnabled NOTIFY loopEnabledChanged)
    Q_PROPERTY(int intervalMs READ intervalMs WRITE setIntervalMs NOTIFY intervalMsChanged)
    Q_PROPERTY(int totalSteps READ totalSteps NOTIFY totalStepsChanged)
    Q_PROPERTY(int maxLoops READ maxLoops WRITE setMaxLoops NOTIFY maxLoopsChanged)
    Q_PROPERTY(int currentLoop READ currentLoop NOTIFY currentLoopChanged)

public:
    explicit PositionSequencer(QObject *parent = nullptr);

    // Property accessors
    bool isRunning() const { return m_isRunning; }
    int currentIndex() const { return m_currentIndex; }
    bool loopEnabled() const { return m_loopEnabled; }
    int intervalMs() const { return m_intervalMs; }
    int totalSteps() const { return m_positions.size(); }

    void setLoopEnabled(bool enabled);
    void setIntervalMs(int ms);

    int maxLoops() const { return m_maxLoops; }
    int currentLoop() const { return m_currentLoop; }
    void setMaxLoops(int loops);

    // Sequence configuration
    Q_INVOKABLE void setPositions(const QVector<int> &positions);
    Q_INVOKABLE void generatePositions(int startPulse, int endPulse, int steps);
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void reset();

    // Accessors
    Q_INVOKABLE QVector<int> getPositions() const { return m_positions; }
    Q_INVOKABLE int getCurrentPosition() const;

signals:
    void runningStateChanged(bool running);
    void currentIndexChanged(int index);
    void loopEnabledChanged(bool enabled);
    void intervalMsChanged(int ms);
    void totalStepsChanged(int total);
    void nextPosition(int position, int index);
    void sequenceCompleted();
    void maxLoopsChanged(int loops);
    void currentLoopChanged(int loop);

private slots:
    void advanceSequence();

private:
    void updateRunningState(bool running);

    QTimer *m_sequenceTimer;
    QVector<int> m_positions;
    int m_currentIndex;
    bool m_isRunning;
    bool m_loopEnabled;
    bool m_isForward;
    int m_intervalMs;
    int m_maxLoops;
    int m_currentLoop;

    static constexpr int DEFAULT_INTERVAL_MS = 1500;
    static constexpr int DEFAULT_MAX_LOOPS = 4;
};

#endif // POSITIONSEQUENCER_H
