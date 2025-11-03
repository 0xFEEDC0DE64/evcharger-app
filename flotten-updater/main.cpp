#include <QApplication>
#include <QMessageBox>
#include <QDebug>

#include "flottenupdatersettings.h"
#include "importcredentialsdialog.h"
#include "mainwindow.h"

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

    QApplication app{argc, argv};

    QCoreApplication::setOrganizationName("feedc0de");
    QCoreApplication::setOrganizationDomain("brunner.ninja");
    QCoreApplication::setApplicationName("flotten-updater");

#ifdef Q_OS_WIN
    if (QSslSocket::availableBackends().contains("schannel"))
        QSslSocket::setActiveBackend("schannel");
#endif

    FlottenUpdaterSettings settings;
    QByteArray username = settings.username();
    QByteArray password = settings.password();

    if (username.isEmpty())
        goto loadCredentials;

    if (password.isEmpty())
        goto loadCredentials;

    goto showMainWindow;

    {
        loadCredentials:
        ImportCredentialsDialog dialog;
        if (dialog.exec() != QDialog::Accepted)
            return 0;

        username = dialog.username();
        password = dialog.password();
        settings.setUsername(username);
        settings.setPassword(password);
    }

    showMainWindow:

    MainWindow mainWindow{settings, username, password};
    mainWindow.show();

    return app.exec();
}
