#include "flottenupdatersettings.h"

QByteArray FlottenUpdaterSettings::privateKey() const
{
    return value("privateKey").toByteArray();
}

void FlottenUpdaterSettings::setPrivateKey(const QByteArray &key)
{
    setValue("privateKey", key);
}

QByteArray FlottenUpdaterSettings::privateCert() const
{
    return value("privateCert").toByteArray();
}

void FlottenUpdaterSettings::setPrivateCert(const QByteArray &cert)
{
    setValue("privateCert", cert);
}
