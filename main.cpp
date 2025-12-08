#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QQuickWindow>

#include "src/core/ApplicationController.h"
#include "src/serial/SerialPortManager.h"
#include "src/control/DeviceController.h"
#include "src/control/PositionSequencer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Set application metadata
    app.setOrganizationName("TavanAfarin");
    app.setOrganizationDomain("TavanAfarin.local");
    app.setApplicationName("Quality Control");
    app.setApplicationVersion("1.0.1");
    // app.setWindowIcon(QIcon("qrc:/Resources/Icons/QualityControl.ico"));

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


    auto rootWindow = qobject_cast<QQuickWindow*>(engine.rootObjects().constFirst());
    if (rootWindow) {
        rootWindow->setIcon(QIcon("qrc:/Resources/Icons/QualityControl.ico"));
    }

    return app.exec();
}
