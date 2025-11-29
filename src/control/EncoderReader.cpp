#include "EncoderReader.h"
#include "../serial/EncoderDevice.h"
#include <QDebug>

namespace {
// If device returns "123\n"
const QRegularExpression PACKET_REGEX("^(-?\\d+)\\n");
}

EncoderReader::EncoderReader(QObject *parent)
    : QObject(parent)
    , m_encoderDevice(nullptr)
    , m_currentAngle(0.0f)
    , m_isReading(false)
{
    m_readTimer.setInterval(READ_INTERVAL_MS);
    connect(&m_readTimer, &QTimer::timeout,
            this, &EncoderReader::requestPosition);
}

EncoderReader::~EncoderReader()
{
    stopReading();
}

void EncoderReader::setEncoderDevice(EncoderDevice *device)
{
    m_encoderDevice = device;

    if (m_encoderDevice) {
        connect(m_encoderDevice, &EncoderDevice::positionReceived,
                this, &EncoderReader::handlePositionReceived);
        connect(m_encoderDevice, &EncoderDevice::errorOccurred,
                this, &EncoderReader::handleEncoderError);
    }
}

void EncoderReader::onDataReceived(const QByteArray &data)
{
    // This would be called if we were directly managing data
    // In our architecture, EncoderDevice handles this
    Q_UNUSED(data)
}

void EncoderReader::startReading()
{
    if (!m_encoderDevice) {
        emit errorOccurred(QStringLiteral("No encoder device configured"));
        return;
    }

    if (!m_encoderDevice->isConnected()) {
        emit errorOccurred(QStringLiteral("Encoder device not connected"));
        return;
    }

    m_isReading = true;
    m_readTimer.start();
    emit readingChanged(m_isReading);

    // Send ready check command
    m_encoderDevice->sendDataAsync(QByteArray("1\n"));
}

void EncoderReader::stopReading()
{
    m_isReading = false;
    m_readTimer.stop();
    emit readingChanged(m_isReading);
}

void EncoderReader::requestPosition()
{
    if (m_encoderDevice && m_encoderDevice->isConnected()) {
        m_encoderDevice->requestPosition();
    }
}

void EncoderReader::handlePositionReceived(float angle)
{
    if (m_currentAngle != angle) {
        m_currentAngle = angle;
        emit angleChanged(m_currentAngle);
    }
}

void EncoderReader::handleEncoderError(const QString &error)
{
    emit errorOccurred(error);
}
