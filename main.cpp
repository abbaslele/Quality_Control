#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include "src/core/ApplicationController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Set application metadata
    app.setOrganizationName("QualityControl");
    app.setOrganizationDomain("qualitycontrol.example.com");
    app.setApplicationName("Servo Encoder Controller");

    // Register C++ types for QML (if needed for instantiation)
    qmlRegisterType<ApplicationController>("QualityControl", 1, 0, "ApplicationController");

    // Create controller on HEAP (not stack) to prevent scope issues
    ApplicationController *appController = new ApplicationController(&app);

    QQmlApplicationEngine engine;

    // Set as context property BEFORE loading QML
    engine.rootContext()->setContextProperty("ApplicationController", appController);

    // Load QML
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
