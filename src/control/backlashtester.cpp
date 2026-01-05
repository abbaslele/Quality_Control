#include "BacklashTester.h"
#include "DeviceController.h"
#include <QDebug>
#include <cmath>
#include <numeric>

BacklashTester::BacklashTester(DeviceController *deviceCtrl, QObject *parent)
    : QObject(parent)
    , m_deviceController(deviceCtrl)
    , m_countdownTimer(new QTimer(this))
    , m_readTimer(new QTimer(this))
    , m_isRunning(false)
    , m_countdown(TEST_DURATION)
    , m_maxAngleForward(0.0)
    , m_maxAngleReverse(0.0)
    , m_avgAngleForward(0.0)
    , m_avgAngleReverse(0.0)
    , m_backlashValueMax(0.0)
    , m_backlashValueAvg(0.0)
    , m_backlashColorMax("green")
    , m_backlashColorAvg("green")
    , m_currentPhase(Idle)
{
    m_countdownTimer->setInterval(1000); // 1 second
    m_readTimer->setInterval(READ_INTERVAL);

    connect(m_countdownTimer, &QTimer::timeout, this, &BacklashTester::onCountdownTick);
    connect(m_readTimer, &QTimer::timeout, this, [this]() {
        m_deviceController->requestEncoderReading();
    });

    if (m_deviceController) {
        connect(m_deviceController, &DeviceController::encoderAngleChanged,
                this, &BacklashTester::onEncoderAngleChanged);
    }
}

void BacklashTester::startTest()
{
    if (m_isRunning) {
        return;
    }

    resetValues();

    m_isRunning = true;
    emit runningChanged(true);
    emit statusMessage("Starting backlash test - Calibrating...");

    // Calibrate and reset encoder
    m_deviceController->setServoToZero();
    QTimer::singleShot(500, this, [this]() {
        m_deviceController->calibrateEncoder();
        QTimer::singleShot(300, this, &BacklashTester::startForwardPhase);
    });
}

void BacklashTester::stopTest()
{
    m_countdownTimer->stop();
    m_readTimer->stop();
    m_isRunning = false;
    m_currentPhase = Idle;
    emit runningChanged(false);
    emit statusMessage("Backlash test stopped");
}

void BacklashTester::resetValues()
{
    m_countdown = TEST_DURATION;
    m_maxAngleForward = 0.0;
    m_maxAngleReverse = 0.0;
    m_avgAngleForward = 0.0;
    m_avgAngleReverse = 0.0;
    m_backlashValueMax = 0.0;
    m_backlashValueAvg = 0.0;
    m_backlashColorMax = "green";
    m_backlashColorAvg = "green";

    m_forwardSamples.clear();
    m_reverseSamples.clear();

    emit countdownChanged(m_countdown);
    emit maxAngleForwardChanged(m_maxAngleForward);
    emit maxAngleReverseChanged(m_maxAngleReverse);
    emit avgAngleForwardChanged(m_avgAngleForward);
    emit avgAngleReverseChanged(m_avgAngleReverse);
    emit backlashValueMaxChanged(m_backlashValueMax);
    emit backlashValueAvgChanged(m_backlashValueAvg);
    emit backlashColorMaxChanged(m_backlashColorMax);
    emit backlashColorAvgChanged(m_backlashColorAvg);
    emit forwardSampleCountChanged(0);
    emit reverseSampleCountChanged(0);
}

void BacklashTester::startForwardPhase()
{
    m_currentPhase = ForwardPhase;
    m_countdown = TEST_DURATION;
    m_maxAngleForward = 0.0;
    m_forwardSamples.clear();

    emit statusMessage("Phase 1: Reading forward direction...");
    emit countdownChanged(m_countdown);
    emit maxAngleForwardChanged(m_maxAngleForward);
    emit avgAngleForwardChanged(0.0);
    emit forwardSampleCountChanged(0);

    m_countdownTimer->start();
    m_readTimer->start();
}

void BacklashTester::startReversePhase()
{
    m_currentPhase = ReversePhase;
    m_countdown = TEST_DURATION;
    m_maxAngleReverse = 0.0;
    m_reverseSamples.clear();

    emit statusMessage("Phase 2: Reading reverse direction...");
    emit countdownChanged(m_countdown);
    emit maxAngleReverseChanged(m_maxAngleReverse);
    emit avgAngleReverseChanged(0.0);
    emit reverseSampleCountChanged(0);

    m_countdownTimer->start();
    m_readTimer->start();
}

void BacklashTester::onCountdownTick()
{
    m_countdown--;
    emit countdownChanged(m_countdown);

    if (m_countdown <= 0) {
        onPhaseComplete();
    }
}

void BacklashTester::onEncoderAngleChanged(double angle)
{
    if (!m_isRunning) {
        return;
    }

    // Validate the reading - reject values with absolute value > 2.5 degrees
    double absAngle = std::abs(angle);
    if (absAngle > MAX_VALID_ANGLE) {
        qWarning() << "Invalid encoder reading detected (> 2.5°):" << angle
                   << "- Skipping this sample";
        emit statusMessage(QString("Warning: Invalid reading %1° ignored (> 2.5°)")
                               .arg(angle, 0, 'f', 3));
        return; // Skip this invalid reading
    }

    if (m_currentPhase == ForwardPhase) {
        // Store all valid forward samples
        m_forwardSamples.append(angle);
        emit forwardSampleCountChanged(m_forwardSamples.size());

        // Track maximum positive angle
        if (angle > m_maxAngleForward) {
            m_maxAngleForward = angle;
            emit maxAngleForwardChanged(m_maxAngleForward);
        }

        // Calculate and emit running average
        m_avgAngleForward = calculateAverage(m_forwardSamples);
        emit avgAngleForwardChanged(m_avgAngleForward);

    } else if (m_currentPhase == ReversePhase) {
        // Store all valid reverse samples
        m_reverseSamples.append(angle);
        emit reverseSampleCountChanged(m_reverseSamples.size());

        // Track maximum absolute negative angle
        if (std::abs(angle) > std::abs(m_maxAngleReverse)) {
            m_maxAngleReverse = angle;
            emit maxAngleReverseChanged(m_maxAngleReverse);
        }

        // Calculate and emit running average
        m_avgAngleReverse = calculateAverage(m_reverseSamples);
        emit avgAngleReverseChanged(m_avgAngleReverse);
    }
}

void BacklashTester::onPhaseComplete()
{
    m_countdownTimer->stop();
    m_readTimer->stop();

    if (m_currentPhase == ForwardPhase) {
        // Calculate final average for forward phase
        m_avgAngleForward = calculateAverage(m_forwardSamples);
        emit avgAngleForwardChanged(m_avgAngleForward);

        emit statusMessage(QString("Forward phase complete. Max: %1°, Avg: %2°, Valid Samples: %3")
                               .arg(m_maxAngleForward, 0, 'f', 3)
                               .arg(m_avgAngleForward, 0, 'f', 3)
                               .arg(m_forwardSamples.size()));

        QTimer::singleShot(500, this, &BacklashTester::startReversePhase);

    } else if (m_currentPhase == ReversePhase) {
        // Calculate final average for reverse phase
        m_avgAngleReverse = calculateAverage(m_reverseSamples);
        emit avgAngleReverseChanged(m_avgAngleReverse);

        emit statusMessage(QString("Reverse phase complete. Max: %1°, Avg: %2°, Valid Samples: %3")
                               .arg(std::abs(m_maxAngleReverse), 0, 'f', 3)
                               .arg(std::abs(m_avgAngleReverse), 0, 'f', 3)
                               .arg(m_reverseSamples.size()));

        calculateBacklash();
        m_isRunning = false;
        m_currentPhase = Idle;
        emit runningChanged(false);
        emit testCompleted();
    }
}

void BacklashTester::calculateBacklash()
{
    // Calculate maximum backlash (sum of absolute max values)
    m_backlashValueMax = std::abs(m_maxAngleForward) + std::abs(m_maxAngleReverse);
    emit backlashValueMaxChanged(m_backlashValueMax);

    // Calculate average backlash (sum of absolute average values)
    m_backlashValueAvg = std::abs(m_avgAngleForward) + std::abs(m_avgAngleReverse);
    emit backlashValueAvgChanged(m_backlashValueAvg);

    updateBacklashColors();

    emit statusMessage(QString("Test completed! Max Backlash: %1°, Avg Backlash: %2° (Total valid samples: %3)")
                           .arg(m_backlashValueMax, 0, 'f', 3)
                           .arg(m_backlashValueAvg, 0, 'f', 3)
                           .arg(m_forwardSamples.size() + m_reverseSamples.size()));
}

void BacklashTester::updateBacklashColors()
{
    // Color for maximum backlash
    if (m_backlashValueMax > BACKLASH_THRESHOLD) {
        m_backlashColorMax = "red";
    } else {
        m_backlashColorMax = "green";
    }
    emit backlashColorMaxChanged(m_backlashColorMax);

    // Color for average backlash
    if (m_backlashValueAvg > BACKLASH_THRESHOLD) {
        m_backlashColorAvg = "red";
    } else {
        m_backlashColorAvg = "green";
    }
    emit backlashColorAvgChanged(m_backlashColorAvg);
}

double BacklashTester::calculateAverage(const QVector<double> &samples) const
{
    if (samples.isEmpty()) {
        return 0.0;
    }

    double sum = std::accumulate(samples.begin(), samples.end(), 0.0);
    return sum / samples.size();
}
