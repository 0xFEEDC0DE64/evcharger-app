#pragma once

#include <QObject>
#include <QQmlEngine>

#include "deviceconnection.h"

class ApiKeyExistanceHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(DeviceConnection* deviceConnection READ deviceConnection WRITE setDeviceConnection NOTIFY deviceConnectionChanged FINAL)
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged FINAL)
    Q_PROPERTY(bool exists READ exists NOTIFY existsChanged STORED false FINAL)

public:
    DeviceConnection *deviceConnection() { return m_deviceConnection; }
    const DeviceConnection *deviceConnection() const { return m_deviceConnection; }
    void setDeviceConnection(DeviceConnection *deviceConnection);

    const QString &apiKey() const { return m_apiKey; }
    void setApiKey(const QString &apiKey);

    bool exists() { return m_exists; }

private slots:
    void fullStatusReceived();

signals:
    void deviceConnectionChanged(DeviceConnection *deviceConnection);
    void apiKeyChanged(const QString &apiKey);
    void existsChanged(bool exists);

private:
    DeviceConnection *m_deviceConnection{};
    QString m_apiKey;
    bool m_exists{};
};
