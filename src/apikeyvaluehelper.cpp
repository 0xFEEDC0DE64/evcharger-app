#include "apikeyvaluehelper.h"

void ApiKeyValueHelper::setDeviceConnection(DeviceConnection *deviceConnection)
{
    if (m_deviceConnection == deviceConnection)
        return;

    if (m_deviceConnection)
    {
        disconnect(m_deviceConnection, &DeviceConnection::fullStatusReceived,
                   this, &ApiKeyValueHelper::fullStatusReceived);
        disconnect(m_deviceConnection, &DeviceConnection::valueChanged,
                   this, &ApiKeyValueHelper::valueChangedSlot);
    }

    emit deviceConnectionChanged(m_deviceConnection = deviceConnection);

    if (m_deviceConnection)
    {
        connect(m_deviceConnection, &DeviceConnection::fullStatusReceived,
                this, &ApiKeyValueHelper::fullStatusReceived);
        connect(m_deviceConnection, &DeviceConnection::valueChanged,
                this, &ApiKeyValueHelper::valueChangedSlot);
    }

    fullStatusReceived();
}

void ApiKeyValueHelper::setApiKey(const QString &apiKey)
{
    if (m_apiKey == apiKey)
        return;

    emit apiKeyChanged(m_apiKey = apiKey);

    fullStatusReceived();
}

void ApiKeyValueHelper::fullStatusReceived()
{
    if (!m_deviceConnection)
    {
        if (m_value.isValid())
            emit valueChanged(m_value = {});
        if (m_exists)
            emit existsChanged(m_exists = false);
        return;
    }

    const auto &fullStatus = m_deviceConnection->getFullStatus();
    const auto iter = fullStatus.find(m_apiKey);

    QVariant value;
    bool exists{};

    if (iter != std::cend(fullStatus))
    {
        value = *iter;
        exists = true;
    }

    if (m_value != value)
        emit valueChanged(m_value = value);

    if (m_exists != exists)
        emit existsChanged(m_exists = exists);
}

void ApiKeyValueHelper::valueChangedSlot(const QString &key, const QVariant &value)
{
    if (m_apiKey != key)
        return;

    if (m_value != value)
        emit valueChanged(m_value = value);

    if (!m_exists)
        emit existsChanged(m_exists = true);
}
