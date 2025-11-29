#ifndef ENCODERTEST_H
#define ENCODERTEST_H

#include <QObject>
#include <QtTest>

/**
 * @class EncoderReaderTest
 * @brief Unit tests for EncoderReader
 */
class EncoderReaderTest : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    void testPositionParsing();
    void testResetPosition();
    void testConnectionStatus();

private:
    EncoderReader *reader;
};

#endif // ENCODERTEST_H
