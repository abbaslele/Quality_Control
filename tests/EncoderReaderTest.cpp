#include "tests/EncoderReaderTest.h"
#include "src/control/EncoderReader.h"

void EncoderReaderTest::initTestCase()
{
    reader = new EncoderReader();
}

void EncoderReaderTest::cleanupTestCase()
{
    delete reader;
}

void EncoderReaderTest::testPositionParsing()
{
    // Test standard format
    reader->onDataReceived(QByteArray("ENC:1234\n"));
    QCOMPARE(reader->currentPosition(), 1234);

    // Test fallback format
    reader->onDataReceived(QByteArray("5678"));
    QCOMPARE(reader->currentPosition(), 5678);
}

void EncoderReaderTest::testResetPosition()
{
    reader->onDataReceived(QByteArray("ENC:5000\n"));
    QCOMPARE(reader->currentPosition(), 5000);

    reader->resetPosition();
    QCOMPARE(reader->currentPosition(), 0);
}

void EncoderReaderTest::testConnectionStatus()
{
    QVERIFY(!reader->isConnected());

    // Simulate data reception (should mark as connected)
    reader->onDataReceived(QByteArray("ENC:1000\n"));
    QVERIFY(reader->isConnected());
}
