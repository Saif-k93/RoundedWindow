#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "cpp/windowshape.h"
#include "cpp/screenhandler.h"



int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    WindowShape window;
    engine.rootContext()->setContextProperty("WindowShape", &window);

    ScreenHandler screen;
    engine.rootContext()->setContextProperty("ScreenHandler", &screen);

    const QUrl url(u"qrc:/RoundedWindow/Main.qml"_qs);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);


    return app.exec();
}
