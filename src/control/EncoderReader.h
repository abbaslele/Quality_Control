#ifndef ENCODERREADER_H
#define ENCODERREADER_H

#include <QObject>
#include <QTimer>
#include "../interfaces/IDataReceiver.h"

class EncoderDevice;

/**
 * @class EncoderReader
 * @brief Processes encoder feedback data
 *
 * Manages continuous encoder position reading and parsing.
 * Implements OCP through strategy pattern for protocols.
 */
class EncoderReader : public QObject, public IDataReceiver
{
    Q_OBJECT
    Q_INTERFACES(IDataReceiver)  // Declare interface implementation

public:
    explicit EncoderReader(QObject *parent = nullptr);
    ~EncoderReader();

    /**
     * @brief Set encoder device for communication
     * @param device Encoder device instance
     */
    void setEncoderDevice(EncoderDevice *device);

    // IDataReceiver interface
    void onDataReceived(const QByteArray &data) override;

    /**
     * @brief Get current encoder angle
     * @return Angle in degrees
     */
    float currentAngle() const { return m_currentAngle; }

    /**
     * @brief Check if actively reading
     * @return Reading status
     */
    bool isReading() const { return m_isReading; }

signals:
    void angleChanged(float angle);
    void readingChanged(bool reading);
    void errorOccurred(const QString &message);

public slots:
    void startReading();
    void stopReading();

private slots:
    void requestPosition();
    void handlePositionReceived(float angle);
    void handleEncoderError(const QString &error);

private:
    EncoderDevice *m_encoderDevice;
    QTimer m_readTimer;
    float m_currentAngle;
    bool m_isReading;

    static constexpr int READ_INTERVAL_MS = 100; // 10Hz update rate
};

#endif // ENCODERREADER_H
