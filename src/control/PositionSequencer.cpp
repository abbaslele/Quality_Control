#include "PositionSequencer.h"
#include <QDebug>
#include <QtMath>

static constexpr int DEFAULT_INTERVAL_MS = 1000;

PositionSequencer::PositionSequencer(QObject *parent)
    : QObject(parent)
    , m_currentIndex(0)
    , m_isRunning(false)
    , m_isForwardDirection(true)
    , m_startPosition(900)
    , m_stopPosition(2100)
    , m_stepCount(10)
    , m_startAngle(-75.0f)
    , m_stopAngle(75.0f)
    , m_useAngleMapping(false)
{
    m_sequenceTimer.setInterval(DEFAULT_INTERVAL_MS);
    connect(&m_sequenceTimer, &QTimer::timeout,
            this, &PositionSequencer::processNextPosition);

    // Calculate initial positions
    calculatePositions();
}

PositionSequencer::~PositionSequencer()
{
    stop();
}

void PositionSequencer::setStartPosition(int position)
{
    if (m_startPosition != position) {
        m_startPosition = position;
        emit startPositionChanged(m_startPosition);
        calculatePositions();
    }
}

void PositionSequencer::setStopPosition(int position)
{
    if (m_stopPosition != position) {
        m_stopPosition = position;
        emit stopPositionChanged(m_stopPosition);
        calculatePositions();
    }
}

void PositionSequencer::setStepCount(int count)
{
    if (count < 2) count = 2; // Minimum 2 steps (start and stop)
    if (m_stepCount != count) {
        m_stepCount = count;
        emit stepCountChanged(m_stepCount);
        calculatePositions();
    }
}

void PositionSequencer::setStartAngle(float angle)
{
    if (m_startAngle != angle) {
        m_startAngle = angle;
        emit startAngleChanged(m_startAngle);
        if (m_useAngleMapping) calculatePositions();
    }
}

void PositionSequencer::setStopAngle(float angle)
{
    if (m_stopAngle != angle) {
        m_stopAngle = angle;
        emit stopAngleChanged(m_stopAngle);
        if (m_useAngleMapping) calculatePositions();
    }
}

void PositionSequencer::setUseAngleMapping(bool use)
{
    if (m_useAngleMapping != use) {
        m_useAngleMapping = use;
        emit useAngleMappingChanged(m_useAngleMapping);
        calculatePositions();
    }
}

float PositionSequencer::positionToAngle(int position) const
{
    if (m_startPosition == m_stopPosition) return m_startAngle;

    float ratio = float(position - m_startPosition) / float(m_stopPosition - m_startPosition);
    return m_startAngle + ratio * (m_stopAngle - m_startAngle);
}

int PositionSequencer::angleToPosition(float angle) const
{
    if (m_startAngle == m_stopAngle) return m_startPosition;

    float ratio = (angle - m_startAngle) / (m_stopAngle - m_startAngle);
    return m_startPosition + qRound(ratio * (m_stopPosition - m_startPosition));
}

void PositionSequencer::calculatePositions()
{
    QVector<int> newPositions;

    if (m_useAngleMapping) {
        // Calculate based on equal angle increments
        float angleStep = (m_stopAngle - m_startAngle) / (m_stepCount - 1);
        for (int i = 0; i < m_stepCount; ++i) {
            float angle = m_startAngle + i * angleStep;
            newPositions.append(angleToPosition(angle));
        }
    } else {
        // Calculate based on equal pulse increments
        int pulseStep = qRound(float(m_stopPosition - m_startPosition) / (m_stepCount - 1));
        for (int i = 0; i < m_stepCount; ++i) {
            newPositions.append(m_startPosition + i * pulseStep);
        }
    }

    m_positions = newPositions;
    emit positionsChanged(m_positions);
    qDebug() << "Calculated positions:" << m_positions;
}

void PositionSequencer::start()
{
    if (m_positions.isEmpty()) {
        qWarning() << "No positions configured";
        return;
    }

    m_isRunning = true;
    m_currentIndex = 0;
    m_isForwardDirection = true;
    emit runningChanged(m_isRunning);
    emit indexChanged(m_currentIndex);

    qDebug() << "Position sequencer started with" << m_positions.size() << "positions";

    // Trigger first position immediately
    processNextPosition();
}

void PositionSequencer::stop()
{
    if (m_isRunning) {
        m_isRunning = false;
        m_sequenceTimer.stop();
        emit runningChanged(m_isRunning);
        qDebug() << "Position sequencer stopped";
    }
}

void PositionSequencer::processNextPosition()
{
    if (!m_isRunning || m_positions.isEmpty()) {
        return;
    }

    int currentPosition = m_positions[m_currentIndex];
    float currentAngle = positionToAngle(currentPosition);

    emit positionTriggered(currentPosition, currentAngle);

    // Wait 1 second total: 500ms for servo move + 500ms for encoder read
    if (m_isRunning) {
        m_sequenceTimer.start(1000);
    }

    advanceSequence();
}

void PositionSequencer::advanceSequence()
{
    if (m_isForwardDirection) {
        m_currentIndex++;
        if (m_currentIndex >= m_positions.size()) {
            m_currentIndex = qMax(0, m_positions.size() - 2);
            m_isForwardDirection = false;

            if (m_currentIndex < 0) {
                stop();
                emit sequenceCompleted();
                return;
            }
        }
    } else {
        m_currentIndex--;
        if (m_currentIndex < 0) {
            emit sequenceCompleted();
            m_currentIndex = 0;
            m_isForwardDirection = true;
        }
    }

    emit indexChanged(m_currentIndex);
}
