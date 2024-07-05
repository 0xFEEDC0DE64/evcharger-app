#include "apikeyexistancehelper.h"

void ApiKeyExistanceHelper::setDeviceConnection(DeviceConnection *deviceConnection)
{
    if (m_deviceConnection == deviceConnection)
        return;

    if (m_deviceConnection)
    {
        disconnect(m_deviceConnection, &DeviceConnection::fullStatusReceived,
                   this, &ApiKeyExistanceHelper::fullStatusReceived);
    }

    emit deviceConnectionChanged(m_deviceConnection = deviceConnection);

    if (m_deviceConnection)
    {
        connect(m_deviceConnection, &DeviceConnection::fullStatusReceived,
                this, &ApiKeyExistanceHelper::fullStatusReceived);

        fullStatusReceived();
    }
    else if (m_exists)
        emit existsChanged(m_exists = false);
}

void ApiKeyExistanceHelper::setApiKey(const QString &apiKey)
{
    if (m_apiKey == apiKey)
        return;

    emit apiKeyChanged(m_apiKey = apiKey);

    if (m_deviceConnection)
        fullStatusReceived();
    else if (m_exists)
        emit existsChanged(m_exists = false);
}

void ApiKeyExistanceHelper::fullStatusReceived()
{
    if (!m_deviceConnection)
    {
        if (m_exists)
            emit existsChanged(m_exists = false);
        return;
    }

    const auto exists = m_deviceConnection->getFullStatus().contains(m_apiKey);

    if (exists != m_exists)
        emit existsChanged(m_exists = exists);
}
