#include "appsettings.h"

#include <algorithm>

std::vector<SavedDevice> AppSettings::getSavedDevices()
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

void AppSettings::saveSavedDevices(const std::vector<SavedDevice> &savedDevices)
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

void AppSettings::refreshSavedDevice(SavedDevice &&savedDevice)
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

void AppSettings::removeSavedDevice(const QString &serial)
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

int AppSettings::numberOfAppInstances() const
{
    if (!m_numberOfAppInstances)
    {
        bool ok{};
        int numberOfAppInstances = value("numberOfAppInstances", 1).toInt(&ok);
        if (!ok)
            numberOfAppInstances = 1;
        m_numberOfAppInstances = numberOfAppInstances;
        return numberOfAppInstances;
    }

    return *m_numberOfAppInstances;
}

void AppSettings::setNumberOfAppInstances(int numberOfAppInstances)
{
    setValue("numberOfAppInstances", numberOfAppInstances);
    m_numberOfAppInstances = numberOfAppInstances;
    emit numberOfAppInstancesChanged(numberOfAppInstances);
}
