#include "appsettings.h"

#include <QFile>
#include <QQmlFile>

bool AppSettings::loadSolalawebKey(const QString &url)
{
    QFile file{QQmlFile::urlToLocalFileOrQrc(url)};
    if (!file.open(QFile::ReadOnly))
    {
        qWarning() << "Could not open file:" << file.errorString();
        return false;
    }

    setSolalawebKey(file.readAll());

    return true;
}

bool AppSettings::loadSolalawebCert(const QString &url)
{
    QFile file{QQmlFile::urlToLocalFileOrQrc(url)};
    if (!file.open(QFile::ReadOnly))
    {
        qWarning() << "Could not open file:" << file.errorString();
        return false;
    }

    setSolalawebCert(file.readAll());

    return true;
}
