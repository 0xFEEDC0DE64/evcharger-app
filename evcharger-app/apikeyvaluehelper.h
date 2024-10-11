#pragma once

#include <QObject>
#include <QQmlEngine>

#include "deviceconnection.h"

class ApiKeyValueHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(DeviceConnection* deviceConnection READ deviceConnection WRITE setDeviceConnection NOTIFY deviceConnectionChanged FINAL)
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged FINAL)
    Q_PROPERTY(QVariant value READ value NOTIFY valueChanged STORED false FINAL)
    Q_PROPERTY(bool exists READ exists NOTIFY existsChanged STORED false FINAL)

public:
    DeviceConnection *deviceConnection() { return m_deviceConnection; }
    const DeviceConnection *deviceConnection() const { return m_deviceConnection; }
    void setDeviceConnection(DeviceConnection *deviceConnection);

    const QString &apiKey() const { return m_apiKey; }
    void setApiKey(const QString &apiKey);

    const QVariant &value() { return m_value; }
    bool exists() const { return m_exists; }

private slots:
    void fullStatusReceived();
    void valueChangedSlot(const QString &key, const QVariant &value);

signals:
    void deviceConnectionChanged(DeviceConnection *deviceConnection);
    void apiKeyChanged(const QString &apiKey);
    void valueChanged(const QVariant &variant);
    void existsChanged(bool exists);

private:
    DeviceConnection *m_deviceConnection{};
    QString m_apiKey;
    QVariant m_value;
    bool m_exists{};
};
