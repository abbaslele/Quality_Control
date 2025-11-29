#include "ServoControllerTest.h"
#include "src/control/ServoController.h"

void ServoControllerTest::initTestCase()
{
    mockDevice = new MockDataTransmitter();
    controller = new ServoController(mockDevice);
}

void ServoControllerTest::cleanupTestCase()
{
    delete controller;
    delete mockDevice;
}

void ServoControllerTest::testPositionSequence()
{
    QList<int> testSequence = {1000, 1500, 2000};
    controller->setPositionSequence(testSequence);

    QCOMPARE(controller->positionSequence(), testSequence);
}

void ServoControllerTest::testStartStopSequence()
{
    QVERIFY(!controller->isRunning());

    controller->startSequence(false);
    QVERIFY(controller->isRunning());

    controller->stopSequence();
    QVERIFY(!controller->isRunning());
}

void ServoControllerTest::testSendPosition()
{
    mockDevice->sendCalled = false;

    controller->sendPosition(1500);

    QVERIFY(mockDevice->sendCalled);
    QVERIFY(mockDevice->lastCommand.contains("1500"));
}

void ServoControllerTest::testInvalidDevice()
{
    ServoController nullController(nullptr);
    QTest::ignoreMessage(QtWarningMsg, "No device configured");

    nullController.sendPosition(1500);
    // Should emit error signal
}
