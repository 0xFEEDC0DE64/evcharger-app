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

QStringList FlottenUpdaterSettings::customColumns() const
{
    return value("customColumns").toStringList();
}

void FlottenUpdaterSettings::setCustomColumns(const QStringList &customColumns)
{
    setValue("customColumns", customColumns);
}

QStringList FlottenUpdaterSettings::serials() const
{
    return value("serials").toStringList();
}

void FlottenUpdaterSettings::setSerials(const QStringList &serials)
{
    setValue("serials", serials);
}
