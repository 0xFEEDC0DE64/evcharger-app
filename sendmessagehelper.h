#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

#include "deviceconnection.h"

class SendMessageHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(DeviceConnection* deviceConnection READ deviceConnection WRITE setDeviceConnection NOTIFY deviceConnectionChanged FINAL)
    Q_PROPERTY(QString requestId READ requestId NOTIFY requestIdChanged STORED false FINAL)
    Q_PROPERTY(bool pending READ pending NOTIFY pendingChanged STORED false FINAL)
    Q_PROPERTY(QVariant response READ response NOTIFY responseChanged FINAL)

public:
    DeviceConnection *deviceConnection() { return m_deviceConnection; }
    const DeviceConnection *deviceConnection() const { return m_deviceConnection; }
    void setDeviceConnection(DeviceConnection *deviceConnection);

    const QString &requestId() const { return m_requestId; }

    bool pending() const { return m_pending; }

    const QVariant &response() const { return m_response; }

    Q_INVOKABLE void sendMessage(QVariantMap message);

signals:
    void deviceConnectionChanged(DeviceConnection *deviceConnection);
    void requestIdChanged(const QString &requestId);
    void pendingChanged(bool pending);
    void responseChanged(const QVariant &response);

private slots:
    void responseReceived(const QString &requestId, const QVariantMap &message);

private:
    DeviceConnection *m_deviceConnection{};
    QString m_requestId;
    bool m_pending{};
    QVariant m_response;
};
