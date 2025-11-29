#include <QtTest>
#include "ServoControllerTest.h"
#include "EncoderReaderTest.h"

/**
 * @file test_main.cpp
 * @brief Main entry point for unit tests
 */

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    int status = 0;

    // Run all test suites
    {
        ServoControllerTest servoTest;
        status |= QTest::qExec(&servoTest, argc, argv);
    }

    {
        EncoderReaderTest encoderTest;
        status |= QTest::qExec(&encoderTest, argc, argv);
    }

    return status;
}
