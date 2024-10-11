#include <QApplication>
#include <QTranslator>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    qSetMessagePattern(QStringLiteral("%{time dd.MM.yyyy HH:mm:ss.zzz} "
                                      "["
                                      "%{if-debug}D%{endif}"
                                      "%{if-info}I%{endif}"
                                      "%{if-warning}W%{endif}"
                                      "%{if-critical}C%{endif}"
                                      "%{if-fatal}F%{endif}"
                                      "] "
                                      "%{function}(): "
                                      "%{message}"));

    QCoreApplication::setOrganizationName("feedc0de");
    QCoreApplication::setOrganizationDomain("brunner.ninja");
    QCoreApplication::setApplicationName("evcharger-app");

    QApplication app(argc, argv);

    QTranslator translator;
    if (!translator.load(QLocale(), "qml", "_", ":/EVChargerApp/i18n/"))
        qWarning("could not load translations!");
    app.installTranslator(&translator);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     [](const QUrl &url){ qFatal("object creation failed: %s", qPrintable(url.toString()));
    });

    engine.loadFromModule("EVChargerApp", "EVChargerApp");

    return app.exec();
}
