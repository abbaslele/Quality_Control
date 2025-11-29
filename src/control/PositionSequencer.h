#ifndef POSITIONSEQUENCER_H
#define POSITIONSEQUENCER_H

#include <QObject>
#include <QTimer>
#include <QVector>

/**
 * @class PositionSequencer
 * @brief Manages servo test position sequence with dynamic calculation
 */
class PositionSequencer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVector<int> positions READ positions NOTIFY positionsChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY indexChanged)
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int startPosition READ startPosition WRITE setStartPosition NOTIFY startPositionChanged)
    Q_PROPERTY(int stopPosition READ stopPosition WRITE setStopPosition NOTIFY stopPositionChanged)
    Q_PROPERTY(int stepCount READ stepCount WRITE setStepCount NOTIFY stepCountChanged)
    Q_PROPERTY(float startAngle READ startAngle WRITE setStartAngle NOTIFY startAngleChanged)
    Q_PROPERTY(float stopAngle READ stopAngle WRITE setStopAngle NOTIFY stopAngleChanged)
    Q_PROPERTY(bool useAngleMapping READ useAngleMapping WRITE setUseAngleMapping NOTIFY useAngleMappingChanged)

public:
    explicit PositionSequencer(QObject *parent = nullptr);
    ~PositionSequencer();

    QVector<int> positions() const { return m_positions; }
    int currentIndex() const { return m_currentIndex; }
    bool isRunning() const { return m_isRunning; }

    // Position properties
    int startPosition() const { return m_startPosition; }
    void setStartPosition(int position);
    int stopPosition() const { return m_stopPosition; }
    void setStopPosition(int position);
    int stepCount() const { return m_stepCount; }
    void setStepCount(int count);

    // Angle properties
    float startAngle() const { return m_startAngle; }
    void setStartAngle(float angle);
    float stopAngle() const { return m_stopAngle; }
    void setStopAngle(float angle);
    bool useAngleMapping() const { return m_useAngleMapping; }
    void setUseAngleMapping(bool use);

    // Conversion methods
    Q_INVOKABLE float positionToAngle(int position) const;
    Q_INVOKABLE int angleToPosition(float angle) const;

signals:
    void positionTriggered(int position, float angle);
    void positionSettled(int position, float angle); // <-- ADD THIS SIGNAL
    void sequenceCompleted();
    void positionsChanged(const QVector<int> &positions);
    void indexChanged(int index);
    void runningChanged(bool running);
    void startPositionChanged(int position);
    void stopPositionChanged(int position);
    void stepCountChanged(int count);
    void startAngleChanged(float angle);
    void stopAngleChanged(float angle);
    void useAngleMappingChanged(bool use);

public slots:
    void start();
    void stop();
    void calculatePositions();

private slots:
    void processNextPosition();

private:
    QTimer m_sequenceTimer;
    QVector<int> m_positions;
    int m_currentIndex;
    bool m_isRunning;
    bool m_isForwardDirection;

    // Configuration
    int m_startPosition;
    int m_stopPosition;
    int m_stepCount;
    float m_startAngle;
    float m_stopAngle;
    bool m_useAngleMapping;

    void advanceSequence();
};

#endif // POSITIONSEQUENCER_H
