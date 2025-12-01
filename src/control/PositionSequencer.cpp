#include "PositionSequencer.h"
#include <QDebug>

PositionSequencer::PositionSequencer(QObject *parent)
    : QObject(parent)
    , m_sequenceTimer(new QTimer(this))
    , m_currentIndex(0)
    , m_isRunning(false)
    , m_loopEnabled(false)
    , m_isForward(true)
    , m_intervalMs(DEFAULT_INTERVAL_MS)
    , m_maxLoops(DEFAULT_MAX_LOOPS)
    , m_currentLoop(0)
{
    m_sequenceTimer->setInterval(m_intervalMs);
    connect(m_sequenceTimer, &QTimer::timeout,
            this, &PositionSequencer::advanceSequence);
}

void PositionSequencer::setLoopEnabled(bool enabled)
{
    if (m_loopEnabled != enabled) {
        m_loopEnabled = enabled;
        emit loopEnabledChanged(enabled);
    }
}

void PositionSequencer::setIntervalMs(int ms)
{
    if (ms < 100) ms = 100; // Minimum 100ms interval

    if (m_intervalMs != ms) {
        m_intervalMs = ms;
        m_sequenceTimer->setInterval(ms);
        emit intervalMsChanged(ms);
    }
}

void PositionSequencer::setPositions(const QVector<int> &positions)
{
    m_positions = positions;
    emit totalStepsChanged(m_positions.size());
    qDebug() << "Positions set:" << positions.size() << "steps";
}

void PositionSequencer::setMaxLoops(int loops)
{
    if (loops < 1) loops = 1;

    if (m_maxLoops != loops) {
        m_maxLoops = loops;
        emit maxLoopsChanged(loops);
    }
}

void PositionSequencer::generatePositions(int startPulse, int endPulse, int steps)
{
    m_positions.clear();

    if (steps < 2) {
        qWarning() << "Steps must be at least 2";
        return;
    }

    double stepSize = static_cast<double>(endPulse - startPulse) / (steps - 1);

    for (int i = 0; i < steps; ++i) {
        int pulse = qRound(startPulse + i * stepSize);
        m_positions.append(pulse);
    }

    emit totalStepsChanged(m_positions.size());
    qDebug() << "Generated positions:" << m_positions;
}

void PositionSequencer::start()
{
    if (m_positions.isEmpty()) {
        qWarning() << "No positions configured";
        return;
    }

    m_currentIndex = 0;
    m_isForward = true;
    m_currentLoop = 0;  // Reset loop counter
    updateRunningState(true);

    emit currentLoopChanged(m_currentLoop);

    // Emit first position immediately
    emit nextPosition(m_positions[m_currentIndex], m_currentIndex);
    emit currentIndexChanged(m_currentIndex);

    m_sequenceTimer->start();
    qDebug() << "Sequence started - will run" << m_maxLoops << "times";
}

void PositionSequencer::stop()
{
    m_sequenceTimer->stop();
    updateRunningState(false);
    qDebug() << "Sequence stopped";
}

void PositionSequencer::pause()
{
    if (m_isRunning) {
        m_sequenceTimer->stop();
        updateRunningState(false);
        qDebug() << "Sequence paused";
    }
}

void PositionSequencer::reset()
{
    stop();
    m_currentIndex = 0;
    m_isForward = true;
    m_currentLoop = 0;
    emit currentIndexChanged(m_currentIndex);
    emit currentLoopChanged(m_currentLoop);
    qDebug() << "Sequence reset";
}

int PositionSequencer::getCurrentPosition() const
{
    if (m_currentIndex >= 0 && m_currentIndex < m_positions.size()) {
        return m_positions[m_currentIndex];
    }
    return 0;
}

void PositionSequencer::advanceSequence()
{
    if (m_positions.isEmpty()) {
        stop();
        return;
    }

    // Move to next position
    if (m_isForward) {
        m_currentIndex++;
        if (m_currentIndex >= m_positions.size()) {
            // Reached end, reverse direction
            m_isForward = false;
            m_currentIndex = m_positions.size() - 2;
        }
    } else {
        m_currentIndex--;
        if (m_currentIndex < 0) {
            // Completed one full cycle (forward + backward)
            m_currentLoop++;
            emit currentLoopChanged(m_currentLoop);

            qDebug() << "Completed loop" << m_currentLoop << "of" << m_maxLoops;

            // Check if we should continue
            if (m_currentLoop >= m_maxLoops) {
                // Finished all loops
                emit sequenceCompleted();
                stop();
                qDebug() << "All" << m_maxLoops << "loops completed";
                return;
            }

            // Start next loop
            if (m_loopEnabled) {
                m_isForward = true;
                m_currentIndex = 0;
            } else {
                // Stop if looping not enabled (respect maxLoops setting)
                emit sequenceCompleted();
                stop();
                return;
            }
        }
    }

    emit currentIndexChanged(m_currentIndex);
    emit nextPosition(m_positions[m_currentIndex], m_currentIndex);
}

void PositionSequencer::updateRunningState(bool running)
{
    if (m_isRunning != running) {
        m_isRunning = running;
        emit runningStateChanged(running);
    }
}
