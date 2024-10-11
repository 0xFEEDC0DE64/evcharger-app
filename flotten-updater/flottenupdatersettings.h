#pragma once

#include <QSettings>

class FlottenUpdaterSettings : public QSettings
{
    Q_OBJECT

public:
    using QSettings::QSettings;

    QByteArray privateKey() const;
    void setPrivateKey(const QByteArray &key);

    QByteArray privateCert() const;
    void setPrivateCert(const QByteArray &cert);
};
