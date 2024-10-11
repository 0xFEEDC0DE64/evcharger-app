#include "goesettings.h"

#include <algorithm>

std::vector<SavedDevice> GoeSettings::getSavedDevices()
{
    std::vector<SavedDevice> savedDevices;

    int size = beginReadArray("devices");
    for (int i = 0; i < size; ++i)
    {
        setArrayIndex(i);
        savedDevices.emplace_back(SavedDevice {
            .serial = value("serial").toString(),
            .manufacturer = value("manufacturer").toString(),
            .deviceType = value("deviceType").toString(),
            .friendlyName = value("friendlyName").toString(),
            .password = value("password").toString(),
        });
    }
    endArray();

    return savedDevices;
}

void GoeSettings::saveSavedDevices(const std::vector<SavedDevice> &savedDevices)
{
    beginWriteArray("devices");
    for (qsizetype i = 0; i < savedDevices.size(); ++i) {
        setArrayIndex(i);
        setValue("serial", savedDevices.at(i).serial);
        setValue("manufacturer", savedDevices.at(i).manufacturer);
        setValue("deviceType", savedDevices.at(i).deviceType);
        setValue("friendlyName", savedDevices.at(i).friendlyName);
        setValue("password", savedDevices.at(i).password);
    }
    endArray();
}

void GoeSettings::refreshSavedDevice(SavedDevice &&savedDevice)
{
    auto savedDevices = getSavedDevices();

    if (auto iter = std::find_if(std::begin(savedDevices), std::end(savedDevices),
                                 [&serial=savedDevice.serial](const SavedDevice &savedDevice){ return savedDevice.serial == serial; });
        iter != std::end(savedDevices))
    {
        if (savedDevice.password.isEmpty())
            savedDevice.password = std::move(iter->password);
        savedDevices.erase(iter);
    }

    savedDevices.emplace(std::begin(savedDevices), std::move(savedDevice));

    saveSavedDevices(savedDevices);
}

void GoeSettings::removeSavedDevice(const QString &serial)
{
    auto savedDevices = getSavedDevices();

    if (auto iter = std::find_if(std::begin(savedDevices), std::end(savedDevices),
                                 [&serial](const SavedDevice &savedDevice){ return savedDevice.serial == serial; });
        iter != std::end(savedDevices))
    {
        savedDevices.erase(iter);
    }

    saveSavedDevices(savedDevices);
}

int GoeSettings::numberOfAppInstances() const
{
    if (m_numberOfAppInstances)
        return *m_numberOfAppInstances;

    bool ok{};
    int numberOfAppInstances = value("numberOfAppInstances", 1).toInt(&ok);
    if (!ok || numberOfAppInstances < 1)
        numberOfAppInstances = 1;
    m_numberOfAppInstances = numberOfAppInstances;
    return numberOfAppInstances;
}

void GoeSettings::setNumberOfAppInstances(int numberOfAppInstances)
{
    if (numberOfAppInstances < 1)
        return;
    setValue("numberOfAppInstances", numberOfAppInstances);
    m_numberOfAppInstances = numberOfAppInstances;
    emit numberOfAppInstancesChanged(numberOfAppInstances);
}

QString GoeSettings::solalawebKey() const
{
    if (m_solalawebKey)
        return *m_solalawebKey;

    auto solalawebKey = value("solalawebKey").toString();
    m_solalawebKey = solalawebKey;
    return solalawebKey;
}

void GoeSettings::setSolalawebKey(const QString &solalawebKey)
{
    setValue("solalawebKey", solalawebKey);
    m_solalawebKey = solalawebKey;
    emit solalawebKeyChanged(solalawebKey);
}

QString GoeSettings::solalawebCert() const
{
    if (m_solalawebCert)
        return *m_solalawebCert;

    auto solalawebCert = value("solalawebCert").toString();
    m_solalawebCert = solalawebCert;
    return solalawebCert;
}

void GoeSettings::setSolalawebCert(const QString &solalawebCert)
{
    setValue("solalawebCert", solalawebCert);
    m_solalawebCert = solalawebCert;
    emit solalawebCertChanged(solalawebCert);
}

bool GoeSettings::showSolalaweb() const
{
    if (m_showSolalaweb)
        return *m_showSolalaweb;

    auto showSolalaweb = value("showSolalaweb").toBool();
    m_showSolalaweb = showSolalaweb;
    return showSolalaweb;
}

void GoeSettings::setShowSolalaweb(bool showSolalaweb)
{
    setValue("showSolalaweb", showSolalaweb);
    m_showSolalaweb = showSolalaweb;
    emit showSolalawebChanged(showSolalaweb);
}
