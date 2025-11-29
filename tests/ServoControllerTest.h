#ifndef SERVOCONTROLLERTEST_H
#define SERVOCONTROLLERTEST_H

#include <QObject>
#include <QtTest>

/**
 * @class MockDataTransmitter
 * @brief Mock implementation for testing
 */
class MockDataTransmitter : public IDataTransmitter
{
public:
    bool sendData(const QByteArray &data) override {
        lastCommand = QString::fromUtf8(data);
        sendCalled = true;
        return true;
    }

    QString lastCommand;
    bool sendCalled = false;
};

/**
 * @class ServoControllerTest
 * @brief Unit tests for ServoController
 */
class ServoControllerTest : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    void testPositionSequence();
    void testStartStopSequence();
    void testSendPosition();
    void testInvalidDevice();

private:
    MockDataTransmitter *mockDevice;
    ServoController *controller;
};

#endif // SERVOCONTROLLERTEST_H
