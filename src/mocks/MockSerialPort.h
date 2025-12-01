#ifndef MOCKSERIALPORT_H
#define MOCKSERIALPORT_H

#include "../interfaces/ISerialPort.h"
#include <QTimer>
#include <QRandomGenerator>  // ADD THIS
#include <QDebug>

class MockSerialPort : public ISerialPort {
    Q_OBJECT

public:
    explicit MockSerialPort(QObject* parent = nullptr) : ISerialPort(parent), m_open(false) {}

    bool open(const QString& portName, qint32 baudRate) override {
        Q_UNUSED(portName)
        Q_UNUSED(baudRate)
        m_open = true;
        emit connectionChanged(true);
        qDebug() << "Mock serial port opened";
        return true;
    }

    void close() override {
        m_open = false;
        emit connectionChanged(false);
        qDebug() << "Mock serial port closed";
    }

    bool isOpen() const override { return m_open; }

    qint64 write(const QByteArray& data) override {
        m_lastWritten = data;

        // FIXED FOR MSVC: Use QObject::connect syntax
        QTimer* timer = new QTimer(this);
        timer->setSingleShot(true);
        connect(timer, &QTimer::timeout, [this, data, timer]() {
            if (data.startsWith('S')) {
                emit dataReceived(QByteArray("Servo command accepted"));
            } else if (data == "E0\n") {
                // FIXED: Use QRandomGenerator
                float mockAngle = QRandomGenerator::global()->bounded(360000) / 1000.0f;
                emit dataReceived(QByteArray::number(mockAngle, 'f', 3));
            } else if (data == "E1\n") {
                emit dataReceived(QByteArray("Encoder is ready and set to Zero position!"));
            }
            timer->deleteLater();
        });
        timer->start(50);

        return data.length();
    }

    QString errorString() const override { return m_error; }

    void simulateError(const QString& error) {
        m_error = error;
        emit errorOccurred(error);
    }

    QByteArray lastWritten() const { return m_lastWritten; }

private:
    bool m_open = false;
    QString m_error;
    QByteArray m_lastWritten;
};

#endif // MOCKSERIALPORT_H
