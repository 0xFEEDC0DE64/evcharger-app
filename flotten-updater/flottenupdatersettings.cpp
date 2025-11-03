#include "flottenupdatersettings.h"

QByteArray FlottenUpdaterSettings::username() const
{
    return value("username").toByteArray();
}

void FlottenUpdaterSettings::setUsername(const QByteArray &username)
{
    setValue("username", username);
}

QByteArray FlottenUpdaterSettings::password() const
{
    return value("password").toByteArray();
}

void FlottenUpdaterSettings::setPassword(const QByteArray &password)
{
    setValue("password", password);
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
