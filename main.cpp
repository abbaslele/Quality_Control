#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "src/core/ApplicationController.h"
#include "src/serial/SerialPortManager.h"
#include "src/control/DeviceController.h"
#include "src/control/PositionSequencer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Set application metadata
    app.setOrganizationName("ServoControl");
    app.setOrganizationDomain("servo-control.local");
    app.setApplicationName("Quality Control");

    // Register QML types
    qmlRegisterType<SerialPortManager>("ServoControl", 1, 0, "SerialPortManager");
    qmlRegisterType<DeviceController>("ServoControl", 1, 0, "DeviceController");
    qmlRegisterType<PositionSequencer>("ServoControl", 1, 0, "PositionSequencer");
    qmlRegisterType<ApplicationController>("ServoControl", 1, 0, "ApplicationController");

    // Create QML engine
    QQmlApplicationEngine engine;

    // Create application controller instance
    ApplicationController appController;

    // Expose to QML context
    engine.rootContext()->setContextProperty("appController", &appController);

    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
