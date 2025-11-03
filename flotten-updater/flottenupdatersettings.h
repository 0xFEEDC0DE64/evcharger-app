#pragma once

#include <QSettings>

class FlottenUpdaterSettings : public QSettings
{
    Q_OBJECT

public:
    using QSettings::QSettings;

    QByteArray username() const;
    void setUsername(const QByteArray &key);

    QByteArray password() const;
    void setPassword(const QByteArray &cert);

    QStringList customColumns() const;
    void setCustomColumns(const QStringList &customColumns);

    QStringList serials() const;
    void setSerials(const QStringList &serials);
};
