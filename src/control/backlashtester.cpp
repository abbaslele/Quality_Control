#include "BacklashTester.h"
#include "DeviceController.h"
#include "../core/ApplicationController.h"
#include <QDebug>
#include <cmath>
#include <numeric>

BacklashTester::BacklashTester(DeviceController *deviceCtrl, ApplicationController *appCtrl, QObject *parent)
    : QObject(parent)
    , m_deviceController(deviceCtrl)
    , m_appController(appCtrl)
    , m_countdownTimer(new QTimer(this))
    , m_readTimer(new QTimer(this))
    , m_isRunning(false)
    , m_countdown(FORWARD_DURATION)
    , m_maxAngleForward(0.0)
    , m_maxAngleReverse(0.0)
    , m_avgAngleForward(0.0)
    , m_avgAngleReverse(0.0)
    , m_backlashValueMax(0.0)
    , m_backlashValueAvg(0.0)
    , m_backlashColorMax("green")
    , m_backlashColorAvg("green")
    , m_currentPhaseText("Idle")
    , m_forwardSampleNumber(0)
    , m_reverseSampleNumber(0)
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

    qDebug() << "======================================";
    qDebug() << "BACKLASH TEST STARTED";
    qDebug() << "======================================";

    emit statusMessage("Starting backlash test...");
    startForwardPhase();
}

void BacklashTester::stopTest()
{
    m_countdownTimer->stop();
    m_readTimer->stop();
    m_isRunning = false;
    m_currentPhase = Idle;
    m_currentPhaseText = "Idle";
    emit runningChanged(false);
    emit currentPhaseTextChanged(m_currentPhaseText);

    qDebug() << "======================================";
    qDebug() << "BACKLASH TEST STOPPED";
    qDebug() << "======================================";

    emit statusMessage("Backlash test stopped");
}

void BacklashTester::resetValues()
{
    m_countdown = FORWARD_DURATION;
    m_maxAngleForward = 0.0;
    m_maxAngleReverse = 0.0;
    m_avgAngleForward = 0.0;
    m_avgAngleReverse = 0.0;
    m_backlashValueMax = 0.0;
    m_backlashValueAvg = 0.0;
    m_backlashColorMax = "green";
    m_backlashColorAvg = "green";
    m_currentPhaseText = "Idle";

    m_forwardSamples.clear();
    m_reverseSamples.clear();
    m_forwardSampleNumber = 0;
    m_reverseSampleNumber = 0;

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
    emit currentPhaseTextChanged(m_currentPhaseText);
}

void BacklashTester::startForwardPhase()
{
    m_currentPhase = ForwardPhase;
    m_countdown = FORWARD_DURATION;
    m_maxAngleForward = 0.0;
    m_forwardSamples.clear();
    m_forwardSampleNumber = 0;
    m_currentPhaseText = "Forward Direction Reading";

    qDebug() << "\n--- PHASE 1: FORWARD DIRECTION ---";
    qDebug() << "Duration:" << FORWARD_DURATION << "seconds";
    qDebug() << "Starting forward phase data collection...";

    emit statusMessage("Phase 1: Reading forward direction (5 seconds)...");
    emit countdownChanged(m_countdown);
    emit maxAngleForwardChanged(m_maxAngleForward);
    emit avgAngleForwardChanged(0.0);
    emit forwardSampleCountChanged(0);
    emit currentPhaseTextChanged(m_currentPhaseText);

    m_countdownTimer->start();
    m_readTimer->start();
}

void BacklashTester::startCalibrationPhase()
{
    m_currentPhase = CalibrationPhase;
    m_currentPhaseText = "Calibrating System";
    emit currentPhaseTextChanged(m_currentPhaseText);

    qDebug() << "\n--- CALIBRATION PHASE ---";
    qDebug() << "Forward phase complete. Starting calibration...";
    qDebug() << "Forward samples collected:" << m_forwardSamples.size();
    qDebug() << "Forward max angle:" << m_maxAngleForward;
    qDebug() << "Forward avg angle:" << m_avgAngleForward;

    emit statusMessage("Forward phase complete. Starting calibration...");

    // Call calibration through ApplicationController
    if (m_appController) {
        m_appController->performCalibration();
        qDebug() << "Calibration command sent to ApplicationController";
    } else {
        qWarning() << "ApplicationController not available for calibration!";
    }

    // Wait for calibration to complete, then start waiting phase
    QTimer::singleShot(1000, this, &BacklashTester::startWaitingPhase);
}

void BacklashTester::startWaitingPhase()
{
    m_currentPhase = WaitingPhase;
    m_countdown = WAITING_DURATION;
    m_currentPhaseText = "Waiting (2 seconds)";
    emit currentPhaseTextChanged(m_currentPhaseText);

    qDebug() << "\n--- WAITING PHASE ---";
    qDebug() << "Calibration complete. Waiting" << WAITING_DURATION << "seconds before reverse phase...";

    emit statusMessage(QString("Calibration complete. Waiting %1 seconds...").arg(WAITING_DURATION));
    emit countdownChanged(m_countdown);

    m_countdownTimer->start();
}

void BacklashTester::startReversePhase()
{
    m_currentPhase = ReversePhase;
    m_countdown = REVERSE_DURATION;
    m_maxAngleReverse = 0.0;
    m_reverseSamples.clear();
    m_reverseSampleNumber = 0;
    m_currentPhaseText = "Reverse Direction Reading";

    qDebug() << "\n--- PHASE 2: REVERSE DIRECTION ---";
    qDebug() << "Duration:" << REVERSE_DURATION << "seconds";
    qDebug() << "Starting reverse phase data collection...";

    emit statusMessage("Phase 2: Reading reverse direction (5 seconds)...");
    emit countdownChanged(m_countdown);
    emit maxAngleReverseChanged(m_maxAngleReverse);
    emit avgAngleReverseChanged(0.0);
    emit reverseSampleCountChanged(0);
    emit currentPhaseTextChanged(m_currentPhaseText);

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

    // Only process readings during forward or reverse phases
    if (m_currentPhase != ForwardPhase && m_currentPhase != ReversePhase) {
        return;
    }

    // Validate the reading - reject values with absolute value > 2.5 degrees
    double absAngle = std::abs(angle);
    if (absAngle > MAX_VALID_ANGLE) {
        qWarning() << "INVALID READING: Angle" << angle
                   << "exceeds maximum valid angle of" << MAX_VALID_ANGLE
                   << "degrees - REJECTED";
        emit statusMessage(QString("Warning: Invalid reading %1° ignored (> 2.5°)")
                               .arg(angle, 0, 'f', 3));
        return; // Skip this invalid reading
    }

    if (m_currentPhase == ForwardPhase) {
        m_forwardSampleNumber++;

        // Log every reading
        logEncoderReading(angle, "FORWARD");

        // Store all valid forward samples
        m_forwardSamples.append(angle);
        emit forwardSampleCountChanged(m_forwardSamples.size());

        // Track maximum positive angle
        if (angle > m_maxAngleForward) {
            double oldMax = m_maxAngleForward;
            m_maxAngleForward = angle;
            emit maxAngleForwardChanged(m_maxAngleForward);
            qDebug() << "  >> NEW MAXIMUM:" << oldMax << "->" << m_maxAngleForward;
        }

        // Calculate and emit running average
        m_avgAngleForward = calculateAverage(m_forwardSamples);
        emit avgAngleForwardChanged(m_avgAngleForward);

    } else if (m_currentPhase == ReversePhase) {
        m_reverseSampleNumber++;

        // Log every reading
        logEncoderReading(angle, "REVERSE");

        // Store all valid reverse samples
        m_reverseSamples.append(angle);
        emit reverseSampleCountChanged(m_reverseSamples.size());

        // Track maximum absolute negative angle
        if (std::abs(angle) > std::abs(m_maxAngleReverse)) {
            double oldMax = m_maxAngleReverse;
            m_maxAngleReverse = angle;
            emit maxAngleReverseChanged(m_maxAngleReverse);
            qDebug() << "  >> NEW MAXIMUM:" << std::abs(oldMax) << "->" << std::abs(m_maxAngleReverse);
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

        qDebug() << "\n--- FORWARD PHASE SUMMARY ---";
        qDebug() << "Maximum angle:" << QString::number(m_maxAngleForward, 'f', 3) << "degrees";
        qDebug() << "Average angle:" << QString::number(m_avgAngleForward, 'f', 3) << "degrees";
        qDebug() << "Valid samples collected:" << m_forwardSamples.size();

        emit statusMessage(QString("Forward phase complete. Max: %1°, Avg: %2°, Samples: %3")
                               .arg(m_maxAngleForward, 0, 'f', 3)
                               .arg(m_avgAngleForward, 0, 'f', 3)
                               .arg(m_forwardSamples.size()));

        // Start calibration phase
        startCalibrationPhase();

    } else if (m_currentPhase == WaitingPhase) {
        qDebug() << "Waiting phase complete. Starting reverse phase...";
        startReversePhase();

    } else if (m_currentPhase == ReversePhase) {
        // Calculate final average for reverse phase
        m_avgAngleReverse = calculateAverage(m_reverseSamples);
        emit avgAngleReverseChanged(m_avgAngleReverse);

        qDebug() << "\n--- REVERSE PHASE SUMMARY ---";
        qDebug() << "Maximum angle:" << QString::number(std::abs(m_maxAngleReverse), 'f', 3) << "degrees";
        qDebug() << "Average angle:" << QString::number(std::abs(m_avgAngleReverse), 'f', 3) << "degrees";
        qDebug() << "Valid samples collected:" << m_reverseSamples.size();

        emit statusMessage(QString("Reverse phase complete. Max: %1°, Avg: %2°, Samples: %3")
                               .arg(std::abs(m_maxAngleReverse), 0, 'f', 3)
                               .arg(std::abs(m_avgAngleReverse), 0, 'f', 3)
                               .arg(m_reverseSamples.size()));

        calculateBacklash();
        m_isRunning = false;
        m_currentPhase = Idle;
        m_currentPhaseText = "Test Complete";
        emit runningChanged(false);
        emit currentPhaseTextChanged(m_currentPhaseText);
        emit testCompleted();
    }
}

void BacklashTester::calculateBacklash()
{
    qDebug() << "\n======================================";
    qDebug() << "BACKLASH CALCULATION";
    qDebug() << "======================================";

    // Calculate maximum backlash (sum of absolute max values)
    m_backlashValueMax = std::abs(m_maxAngleForward) + std::abs(m_maxAngleReverse);
    emit backlashValueMaxChanged(m_backlashValueMax);

    qDebug() << "Maximum Backlash Calculation:";
    qDebug() << "  Forward Max:" << std::abs(m_maxAngleForward) << "degrees";
    qDebug() << "  Reverse Max:" << std::abs(m_maxAngleReverse) << "degrees";
    qDebug() << "  Total Max Backlash:" << m_backlashValueMax << "degrees";

    // Calculate average backlash (sum of absolute average values)
    m_backlashValueAvg = std::abs(m_avgAngleForward) + std::abs(m_avgAngleReverse);
    emit backlashValueAvgChanged(m_backlashValueAvg);

    qDebug() << "\nAverage Backlash Calculation:";
    qDebug() << "  Forward Avg:" << std::abs(m_avgAngleForward) << "degrees";
    qDebug() << "  Reverse Avg:" << std::abs(m_avgAngleReverse) << "degrees";
    qDebug() << "  Total Avg Backlash:" << m_backlashValueAvg << "degrees";

    qDebug() << "\nTotal Valid Samples:" << (m_forwardSamples.size() + m_reverseSamples.size());

    updateBacklashColors();

    qDebug() << "\nTest Result:";
    qDebug() << "  Max Backlash:" << m_backlashValueMax << "degrees -"
             << (m_backlashValueMax > BACKLASH_THRESHOLD ? "EXCESSIVE (RED)" : "ACCEPTABLE (GREEN)");
    qDebug() << "  Avg Backlash:" << m_backlashValueAvg << "degrees -"
             << (m_backlashValueAvg > BACKLASH_THRESHOLD ? "EXCESSIVE (RED)" : "ACCEPTABLE (GREEN)");
    qDebug() << "======================================\n";

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

void BacklashTester::logEncoderReading(double angle, const QString &phase)
{
    int sampleNumber = (phase == "FORWARD") ? m_forwardSampleNumber : m_reverseSampleNumber;
    int totalSamples = (phase == "FORWARD") ? m_forwardSamples.size() : m_reverseSamples.size();
    double currentMax = (phase == "FORWARD") ? m_maxAngleForward : std::abs(m_maxAngleReverse);
    double currentAvg = (phase == "FORWARD") ? m_avgAngleForward : std::abs(m_avgAngleReverse);

    qDebug() << QString("[%1 #%2] Angle: %3° | Max: %4° | Avg: %5° | Samples: %6")
                    .arg(phase, 7)
                    .arg(sampleNumber, 3)
                    .arg(angle, 7, 'f', 3)
                    .arg(currentMax, 7, 'f', 3)
                    .arg(currentAvg, 7, 'f', 3)
                    .arg(totalSamples + 1, 3);

    QString outputResult = QString("[%1 #%2] Angle: %3° | Max: %4° | Avg: %5° | Samples: %6")
                                           .arg(phase, 7)
                                           .arg(sampleNumber, 3)
                                           .arg(angle, 7, 'f', 3)
                                           .arg(currentMax, 7, 'f', 3)
                                           .arg(currentAvg, 7, 'f', 3)
                                           .arg(totalSamples + 1, 3);
    emit backlashoutputLog(outputResult );
}
