#include "sendmessagehelper.h"

#include <QQmlEngine>

void SendMessageHelper::setDeviceConnection(DeviceConnection *deviceConnection)
{
    if (m_deviceConnection == deviceConnection)
        return;

    if (m_deviceConnection)
    {
        disconnect(m_deviceConnection, &DeviceConnection::responseReceived,
                   this, &SendMessageHelper::responseReceived);
    }

    emit deviceConnectionChanged(m_deviceConnection = deviceConnection);

    if (m_deviceConnection)
    {
        connect(m_deviceConnection, &DeviceConnection::responseReceived,
                this, &SendMessageHelper::responseReceived);
    }

    if (!m_requestId.isEmpty())
    {
        m_requestId.clear();
        emit requestIdChanged(m_requestId);
    }

    if (m_pending)
        emit pendingChanged(m_pending = false);

    if (!m_response.isNull())
        emit responseChanged(m_response = {});
}

void SendMessageHelper::sendMessage(QVariantMap message)
{
    if (!m_deviceConnection)
    {
        qWarning() << "No device connection set!";
        qmlEngine(this)->throwError(tr("No device connection set!"));
    }

    emit requestIdChanged(m_requestId = m_deviceConnection->generateRequestId());

    if (!m_pending)
        emit pendingChanged(m_pending = true);

    message["requestId"] = m_requestId;

    m_deviceConnection->sendMessage(message);
}

void SendMessageHelper::responseReceived(const QString &requestId, const QVariantMap &message)
{
    if (m_requestId.isEmpty())
        return;

    if (m_requestId != requestId)
        return;

    if (!m_requestId.isEmpty())
    {
        m_requestId.clear();
        emit requestIdChanged(m_requestId);
    }

    if (m_pending)
        emit pendingChanged(m_pending = false);

    emit responseChanged(m_response = message);
}

