#include <QApplication>
#include <QMessageBox>
#include <QDebug>
#include <QSslKey>
#include <QSslCertificate>
#ifdef Q_OS_WIN
#include <QSslSocket>
#endif

#include "flottenupdatersettings.h"
#include "importcertificatedialog.h"
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
    QByteArray keyBuf = settings.privateKey();
    QByteArray certBuf = settings.privateCert();
    QSslKey key{keyBuf, QSsl::KeyAlgorithm::Rsa, QSsl::Pem};
    QSslCertificate cert{certBuf};

    if (keyBuf.isEmpty())
        goto loadCert;

    if (certBuf.isEmpty())
        goto loadCert;

    if (key.isNull())
    {
        QMessageBox::warning(nullptr,
                             QCoreApplication::translate("main", "Could not parse private key!"),
                             QCoreApplication::translate("main", "Could not parse private key!"));
        goto loadCert;
    }

    if (cert.isNull())
    {
        QMessageBox::warning(nullptr,
                             QCoreApplication::translate("main", "Could not parse private cert!"),
                             QCoreApplication::translate("main", "Could not parse private cert!"));
        goto loadCert;
    }

    goto showMainWindow;

    {
        loadCert:
        ImportCertificateDialog dialog;
        if (dialog.exec() != QDialog::Accepted)
            return 0;

        key = dialog.privateKey();
        cert = dialog.privateCert();
        settings.setPrivateKey(key.toPem());
        settings.setPrivateCert(cert.toPem());
    }

    showMainWindow:

    MainWindow mainWindow{settings, key, cert};
    mainWindow.show();

    return app.exec();
}
