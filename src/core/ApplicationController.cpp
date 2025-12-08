#include "ApplicationController.h"
#include "../serial/SerialPortManager.h"
#include "../control/DeviceController.h"
#include "../control/PositionSequencer.h"
#include <QDebug>
#include <QThread>

ApplicationController::ApplicationController(QObject *parent)
    : QObject(parent)
    , m_settings(new QSettings("ServoControl", "QualityControl", this))
    , m_isCalibrated(false)
    , m_startPulse(DEFAULT_START_PULSE)
    , m_interval(DEFAULT_INTERVAL)
    , m_endPulse(DEFAULT_END_PULSE)
    , m_startAngle(DEFAULT_START_ANGLE)
    , m_endAngle(DEFAULT_END_ANGLE)
    , m_steps(DEFAULT_STEPS)
{
    initializeComponents();
    connectSignals();
    loadSettings();
}

ApplicationController::~ApplicationController()
{
    saveSettings();
}

void ApplicationController::initializeComponents()
{
    m_serialPort = new SerialPortManager(this);
    m_serialPort->setBaudRate(DEFAULT_BAUD_RATE);

    m_deviceController = new DeviceController(m_serialPort, this);
    m_positionSequencer = new PositionSequencer(this);
}

void ApplicationController::connectSignals()
{
    // Connect sequencer to device controller
    connect(m_positionSequencer, &PositionSequencer::nextPosition,
            this, &ApplicationController::handlePositionCommand);

    // Connect encoder updates
    connect(m_deviceController, &DeviceController::encoderAngleChanged,
            this, &ApplicationController::handleEncoderUpdate);

    // Connect sequence completion
    connect(m_positionSequencer, &PositionSequencer::sequenceCompleted,
            this, &ApplicationController::handleSequenceComplete);

    // Forward status messages
    connect(m_deviceController, &DeviceController::deviceError,
            this, &ApplicationController::statusMessage);
    connect(m_serialPort, &SerialPortManager::errorOccurred,
            this, &ApplicationController::statusMessage);
}

QObject* ApplicationController::serialPort() const
{
    return m_serialPort;
}

QObject* ApplicationController::deviceController() const
{
    return m_deviceController;
}

QObject* ApplicationController::positionSequencer() const
{
    return m_positionSequencer;
}

void ApplicationController::setStartPulse(int pulse)
{
    if (m_startPulse != pulse) {
        m_startPulse = pulse;
        emit startPulseChanged(pulse);
    }
}

void ApplicationController::setEndPulse(int pulse)
{
    if (m_endPulse != pulse) {
        m_endPulse = pulse;
        emit endPulseChanged(pulse);
    }
}

void ApplicationController::setStartAngle(double angle)
{
    if (qAbs(m_startAngle - angle) > 0.001) {
        m_startAngle = angle;
        emit startAngleChanged(angle);
    }
}

void ApplicationController::setEndAngle(double angle)
{
    if (qAbs(m_endAngle - angle) > 0.001) {
        m_endAngle = angle;
        emit endAngleChanged(angle);
    }
}

void ApplicationController::setSteps(int steps)
{
    if (m_steps != steps && steps >= 2) {
        m_steps = steps;
        emit stepsChanged(steps);
    }
}

void ApplicationController::performCalibration()
{
    if (!m_serialPort->isConnected()) {
        emit statusMessage("Cannot calibrate: Serial port not connected");
        return;
    }

    emit statusMessage("Starting calibration...");

    // Step 1: Set servo to zero position (1500μs = 0°)
    m_deviceController->  setServoToZero();

    // Step 2: Wait briefly, then reset encoder to zero
    QThread::msleep(500);
    m_deviceController->calibrateEncoder();

    m_isCalibrated = true;
    emit calibrationChanged(true);
    emit statusMessage("Calibration complete");

    qDebug() << "Calibration performed";
}

void ApplicationController::startTest()
{
    if (!m_serialPort->isConnected()) {
        emit statusMessage("Cannot start test: Serial port not connected");
        return;
    }

    if (!m_isCalibrated) {
        emit statusMessage("Please calibrate before running test");
        return;
    }

    m_testResults.clear();

    // Generate position sequence
    m_positionSequencer->generatePositions(m_startPulse, m_endPulse, m_steps);

    // Configure to run 4 complete cycles (forward + backward = 1 cycle)
    m_positionSequencer->setMaxLoops(4);
    m_positionSequencer->setLoopEnabled(true);  // Enable looping

    emit statusMessage("Test started - Running 4 complete cycles");
    m_positionSequencer->start();
}

void ApplicationController::stopTest()
{
    m_positionSequencer->stop();
    emit statusMessage("Test stopped");
}

QVector<double> ApplicationController::calculateRealPositions() const
{
    QVector<double> angles;
    QVector<int> positions = m_positionSequencer->getPositions();

    for (int pulse : positions) {
        double angle = interpolateAngle(pulse);
        angles.append(angle);
    }

    return angles;
}

void ApplicationController::saveSettings()
{
    m_settings->setValue("startPulse", m_startPulse);
    m_settings->setValue("endPulse", m_endPulse);
    m_settings->setValue("startAngle", m_startAngle);
    m_settings->setValue("endAngle", m_endAngle);
    m_settings->setValue("steps", m_steps);
    m_settings->setValue("portName", m_serialPort->portName());
    m_settings->setValue("interval" , m_positionSequencer->intervalMs());
    m_settings->sync();

    qDebug() << "Settings saved";
}

void ApplicationController::loadSettings()
{
    m_startPulse = m_settings->value("startPulse", DEFAULT_START_PULSE).toInt();
    m_endPulse = m_settings->value("endPulse", DEFAULT_END_PULSE).toInt();
    m_startAngle = m_settings->value("startAngle", DEFAULT_START_ANGLE).toDouble();
    m_endAngle = m_settings->value("endAngle", DEFAULT_END_ANGLE).toDouble();
    m_steps = m_settings->value("steps", DEFAULT_STEPS).toInt();
    m_positionSequencer->setIntervalMs(m_settings->value("interval", DEFAULT_INTERVAL).toInt());
    QString portName = m_settings->value("portName", "").toString();
    if (!portName.isEmpty()) {
        m_serialPort->setPortName(portName);
    }

    emit startPulseChanged(m_startPulse);
    emit endPulseChanged(m_endPulse);
    emit startAngleChanged(m_startAngle);
    emit endAngleChanged(m_endAngle);
    emit stepsChanged(m_steps);

    qDebug() << "Settings loaded";
}

void ApplicationController::handlePositionCommand(int position, int index)
{
    // Send servo command
    m_deviceController->sendServoCommand(position);

    // Wait for servo to settle, then read encoder
    QTimer::singleShot(800, this, [this, position, index]() {
        m_deviceController->requestEncoderReading();

        // Store current command position for comparison
        m_testResults.append(qMakePair(position, 0.0));
    });
}

void ApplicationController::handleEncoderUpdate(double angle)
{
    if (!m_testResults.isEmpty()) {
        // Update last test result with encoder reading
        int lastPulse = m_testResults.last().first;
        m_testResults.last().second = angle;

        // Calculate expected angle
        double expectedAngle = interpolateAngle(lastPulse);
        double error = angle - expectedAngle;


        QString msg = QString("Pulse: %1 | Expected: %2° | Actual: %3° | Error: %4°")
                          .arg(lastPulse)
                          .arg(expectedAngle, 0, 'f', 2)
                          .arg(angle, 0, 'f', 2)
                          .arg(error, 0, 'f', 2);

        emit testDataPoint(lastPulse, expectedAngle, angle, error);

        emit statusMessage(msg);
    }
}

void ApplicationController::handleSequenceComplete()
{
    emit statusMessage("Test sequence completed");
    qDebug() << "Test completed with" << m_testResults.size() << "data points";
}

double ApplicationController::interpolateAngle(int pulse) const
{
    if (m_endPulse == m_startPulse) {
        return m_startAngle;
    }

    double ratio = static_cast<double>(pulse - m_startPulse) / (m_endPulse - m_startPulse);
    return m_startAngle + ratio * (m_endAngle - m_startAngle);
}
