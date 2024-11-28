#include "deviceconnection.h"

#include <QDebug>
#include <QMetaEnum>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QPasswordDigestor>
#include <QMessageAuthenticationCode>
#include <QSslConfiguration>
#include <QSslCertificate>
#include <QSslKey>
#include <QTimer>

#include <utility>

#include "msgpack.h"

using namespace std::chrono_literals;

namespace {
template<typename QEnum>
auto enumToString(const QEnum value)
{
    return QMetaEnum::fromType<QEnum>().valueToKey(std::to_underlying(value));
}
}

DeviceConnection::DeviceConnection(QObject *parent) :
    QObject{parent}
{
    connect(&m_websocket, &QWebSocket::connected,
            this, &DeviceConnection::connected);
    connect(&m_websocket, &QWebSocket::disconnected,
            this, &DeviceConnection::disconnected);
    connect(&m_websocket, &QWebSocket::stateChanged,
            this, &DeviceConnection::stateChanged);
    connect(&m_websocket, &QWebSocket::textMessageReceived,
            this, &DeviceConnection::textMessageReceived);
    connect(&m_websocket, &QWebSocket::binaryMessageReceived,
            this, &DeviceConnection::binaryMessageReceived);
    connect(&m_websocket, &QWebSocket::errorOccurred,
            this, &DeviceConnection::errorOccurred);

    connect(&m_websocket, &QWebSocket::peerVerifyError,
            this, &DeviceConnection::peerVerifyError);
    connect(&m_websocket, &QWebSocket::sslErrors,
            this, &DeviceConnection::sslErrors);
    // connect(&m_websocket, &QWebSocket::preSharedKeyAuthenticationRequired,
    //         this, &DeviceConnection::preSharedKeyAuthenticationRequired);
    connect(&m_websocket, &QWebSocket::alertSent,
            this, &DeviceConnection::alertSent);
    connect(&m_websocket, &QWebSocket::alertReceived,
            this, &DeviceConnection::alertReceived);
    connect(&m_websocket, &QWebSocket::handshakeInterruptedOnError,
            this, &DeviceConnection::handshakeInterruptedOnError);
}

void DeviceConnection::setUrl(const QString &url)
{
    if (m_url == url)
        return;

    emit urlChanged(m_url = url);
}

void DeviceConnection::start()
{
    emit logMessage(tr("Connecting to %0").arg(m_url));

    if (m_settings && !m_settings->solalawebKey().isEmpty() && !m_settings->solalawebCert().isEmpty())
    {
        auto sslConfig = m_websocket.sslConfiguration();

        {
            QSslCertificate cert{m_settings->solalawebCert().toUtf8()};
            if (cert.isNull())
            {
                emit logMessage(tr("Could not parse solalaweb certificate!"));
                goto after;
            }
            qDebug() << "cert" << cert.issuerDisplayName();
            sslConfig.setLocalCertificate(cert);
        }

        {
            QSslKey key{m_settings->solalawebKey().toUtf8(), QSsl::KeyAlgorithm::Rsa, QSsl::Pem};
            if (key.isNull())
            {
                emit logMessage(tr("Could not parse solalaweb key!"));
                goto after;
            }
            qDebug() << "key" << key.algorithm();
            sslConfig.setPrivateKey(key);
        }

        m_websocket.setSslConfiguration(sslConfig);
    }

after:
    m_websocket.open(QUrl{m_url});
}

void DeviceConnection::setPassword(const QString &password)
{
    if (m_password == password)
        return;

    emit passwordChanged(m_password = password);
}

void DeviceConnection::messageReceived(const QVariant &variant)
{
    if (variant.typeId() != QMetaType::QVariantMap)
    {
        emit logMessage(tr("Received something that is not a json object!"));
        return;
    }

    const auto &map = variant.toMap();
    auto typeIter = map.find("type");
    if (typeIter == std::cend(map))
    {
        emit logMessage(tr("Received something that does not contain a type!"));
        return;
    }

    const auto &typeVariant = *typeIter;
    if (typeVariant.typeId() != QMetaType::QString)
    {
        emit logMessage(tr("Received something with a non-string type!"));
        return;
    }

    const auto &type = typeVariant.toString();
    qDebug() << type;

    if (type != "fullStatus" && type != "deltaStatus")
        emit logMessage(tr("Received message type %0 %1").arg(type).arg(QJsonDocument::fromVariant(variant).toJson()));

    if (type == "hello")
    {
        {
            auto iter = map.find("serial");
            if (iter == std::cend(map))
            {
                emit logMessage(tr("Received hello without serial!"));
                return;
            }

            const auto &serialVariant = *iter;
            if (serialVariant.typeId() != QMetaType::QString)
            {
                emit logMessage(tr("Received hello with a non-string serial!"));
                return;
            }

            m_serial = serialVariant.toString();
        }

        if (auto iter = map.find("secured"); iter != std::cend(map))
        {
            const auto &securedVariant = *iter;
            if (securedVariant.typeId() != QMetaType::Bool)
            {
                emit logMessage(tr("Received hello with a non-bool secured!"));
                return;
            }

            m_secured = securedVariant.toBool();
        }
        else
            m_secured = false;

        {
            auto manufacturerIter = map.find("manufacturer");
            if (manufacturerIter == std::cend(map))
            {
                emit logMessage(tr("Received hello without manufacturer!"));
                return;
            }

            const auto &manufacturerVariant = *manufacturerIter;
            if (manufacturerVariant.typeId() != QMetaType::QString)
            {
                emit logMessage(tr("Received hello with a non-string manufacturer!"));
                return;
            }

            m_manufacturer = manufacturerVariant.toString();
        }

        {
            auto devicetypeIter = map.find("devicetype");
            if (devicetypeIter == std::cend(map))
            {
                emit logMessage(tr("Received hello without devicetype!"));
                return;
            }

            const auto &deviceTypeVariant = *devicetypeIter;
            if (deviceTypeVariant.typeId() != QMetaType::QString)
            {
                emit logMessage(tr("Received hello with a non-string devicetype!"));
                return;
            }

            m_deviceType = deviceTypeVariant.toString();
        }

        {
            auto friendlyNameIter = map.find("friendly_name");
            if (friendlyNameIter == std::cend(map))
            {
                emit logMessage(tr("Received hello without friendly_name!"));
                return;
            }

            const auto &friendlyNameVariant = *friendlyNameIter;
            if (friendlyNameVariant.typeId() != QMetaType::QString)
            {
                emit logMessage(tr("Received hello with a non-string friendly_name!"));
                return;
            }

            m_friendlyName = friendlyNameVariant.toString();
        }

        if (m_settings)
            m_settings->refreshSavedDevice(SavedDevice {
                .serial = m_serial,
                .manufacturer = m_manufacturer,
                .deviceType = m_deviceType,
                .friendlyName = m_friendlyName
            });
    }
    else if (type == "authRequired")
    {
        {
            auto iter = map.find("token1");
            if (iter == std::cend(map))
            {
                emit logMessage(tr("Received authRequired without token1!"));
                return;
            }

            const auto &token1Variant = *iter;
            if (token1Variant.typeId() != QMetaType::QString)
            {
                emit logMessage(tr("Received authRequired with a non-string token1!"));
                return;
            }

            m_token1 = token1Variant.toString();
        }

        {
            auto iter = map.find("token2");
            if (iter == std::cend(map))
            {
                emit logMessage(tr("Received authRequired without token2!"));
                return;
            }

            const auto &token2Variant = *iter;
            if (token2Variant.typeId() != QMetaType::QString)
            {
                emit logMessage(tr("Received authRequired with a non-string token2!"));
                return;
            }

            m_token2 = token2Variant.toString();
        }

        if (m_password.isEmpty())
            emit authRequired();
        else
            sendAuthInternal();
    }
    else if (type == "fullStatus")
    {
        emit hideDisturbed();

        bool partial{};

        if (auto iter = map.find("partial"); iter != std::cend(map))
        {
            const auto &partialVariant = *iter;
            if (partialVariant.typeId() != QMetaType::Bool)
            {
                emit logMessage(tr("Received fullStatus with a non-bool partial!"));
                return;
            }

            partial = partialVariant.toBool();
        }

        auto iter = map.find("status");
        if (iter == std::cend(map))
        {
            emit logMessage(tr("Received fullStatus without a status!"));
            return;
        }

        const auto &statusVariant = *iter;
        if (statusVariant.typeId() != QMetaType::QVariantMap)
        {
            emit logMessage(tr("Received fullStatus with a non-object status!"));
            return;
        }

        const auto &status = statusVariant.toMap();
        for (auto iter = std::cbegin(status); iter != std::cend(status); iter++)
            m_fullStatus[iter.key()] = iter.value();

        emit logMessage(partial ? tr("Received partial fullStatus") : tr("Received last fullStatus"));

        if (!partial)
            emit fullStatusReceived();
    }
    else if (type == "deltaStatus")
    {
        auto iter = map.find("status");
        if (iter == std::cend(map))
        {
            emit logMessage(tr("Received deltaStatus without a status!"));
            return;
        }

        const auto &statusVariant = *iter;
        if (statusVariant.typeId() != QMetaType::QVariantMap)
        {
            emit logMessage(tr("Received deltaStatus with a non-object status!"));
            return;
        }

        const auto &status = statusVariant.toMap();
        for (auto iter = std::cbegin(status); iter != std::cend(status); iter++)
        {
            m_fullStatus[iter.key()] = iter.value();
            emit valueChanged(iter.key(), iter.value());
            if (iter.key() == "fna")
            {
                const auto &friendlyNameVariant = iter.value();
                if (friendlyNameVariant.typeId() == QMetaType::QString)
                {
                    const auto &friendlyName = friendlyNameVariant.toString();
                    if (m_friendlyName != friendlyName)
                    {
                        m_friendlyName = friendlyName;
                        if (m_settings)
                            m_settings->refreshSavedDevice(SavedDevice {
                                .serial = m_serial,
                                .manufacturer = m_manufacturer,
                                .deviceType = m_deviceType,
                                .friendlyName = m_friendlyName,
                                .password = m_password
                            });
                    }
                }
            }
        }
    }
    else if (type == "offline")
    {
        emit showDisturbed();
    }

    if (auto iter = map.find("requestId"); iter != std::cend(map))
    {
        const auto &requestIdVariant = *iter;
        if (requestIdVariant.typeId() != QMetaType::QString)
        {
            emit logMessage(tr("Received message with a non-string requestId!"));
            return;
        }

        const auto &requestId = requestIdVariant.toString();

        emit responseReceived(requestId, map);

        if (const auto callbackIter = m_callbacks.find(requestId); callbackIter != std::end(m_callbacks))
        {
            if (*callbackIter)
                (*callbackIter)(type, map);
            m_callbacks.erase(callbackIter);
        }
    }
}

void DeviceConnection::sendMessage(QVariantMap variant, callback_t &&callback)
{
    if (callback)
    {
        auto requestId = generateRequestId();
        variant["requestId"] = requestId;
        m_callbacks[requestId] = std::move(callback);
    }

    auto message = QJsonDocument::fromVariant(variant).toJson(QJsonDocument::Compact);

    if (const auto iter = variant.find("type"); m_secured && (iter == std::cend(variant) || *iter != "auth"))
    {
        if (m_password.isEmpty())
        {
            qCritical() << "would have needed secure wrapper but we dont have a password!";
        }
        else
        {
            QString requestId;
            if (const auto iter = variant.find("requestId"); iter != std::cend(variant))
                requestId = iter->toString();

            variant = QVariantMap {
                { "type", "securedMsg" },
                { "data", message },
                { "hmac", QMessageAuthenticationCode::hash(message, m_password.toUtf8(), QCryptographicHash::Sha256).toHex() }
            };
            if (!requestId.isEmpty())
                variant["requestId"] = requestId;
            message = QJsonDocument::fromVariant(variant).toJson(QJsonDocument::Compact);
        }
    }

    //TODO verify that we actually sent the message
    m_websocket.sendTextMessage(message);
    emit logMessage(tr("Sending %0").arg(message));
}

QString DeviceConnection::generateRequestId()
{
    return QString("request-%0").arg(m_requestId++);
}

void DeviceConnection::sendMessage(const QVariantMap &variant)
{
    sendMessage(variant, {});
}

void DeviceConnection::sendAuth(const QString &password)
{
    const QString data = password;
    const QString salt = m_serial;
    constexpr auto iterations = 100000;
    constexpr auto keylen = 64;

    m_password = QPasswordDigestor::deriveKeyPbkdf2(QCryptographicHash::Sha512, data.toUtf8(), salt.toUtf8(), iterations, keylen).toBase64();

    if (m_password.size() > 32)
        m_password.resize(32);

    if (m_websocket.state() != QAbstractSocket::ConnectedState)
        return;

    sendAuthInternal();
}

void DeviceConnection::connected()
{
    qDebug() << "called";
    emit logMessage(tr("Connected!"));
}

void DeviceConnection::disconnected()
{
    qDebug() << "called";
    emit logMessage(tr("Disconnected!"));

    emit showDisturbed();

    emit logMessage(tr("Reconnecting to %0").arg(m_url));
    QTimer::singleShot(1s, this, [this](){
        m_websocket.open(QUrl{m_url});
    });
}

void DeviceConnection::stateChanged(QAbstractSocket::SocketState state)
{
    qDebug() << state;
    emit logMessage(tr("state changed: %0").arg(enumToString(state)));
}

void DeviceConnection::textMessageReceived(const QString &message)
{
    QJsonParseError error;
    QJsonDocument document = QJsonDocument::fromJson(message.toUtf8(), &error);
    if (error.error != QJsonParseError::NoError)
    {
        emit logMessage(tr("could not parse received json: %0 at offset %1").arg(error.errorString()).arg(error.offset));
        return;
    }

    messageReceived(document.toVariant());
}

void DeviceConnection::binaryMessageReceived(QByteArray message)
{
    const auto type = message.at(0);
    switch (type)
    {
    case 0: // Type msgpack
        message.removeFirst();
        messageReceived(MsgPack::unpack(message));
        break;
    default:
        emit logMessage(tr("unknown binary message type %0 received").arg(int(type)));
        break;
    }
}

void DeviceConnection::errorOccurred(QAbstractSocket::SocketError error)
{
    qDebug() << error;
    emit logMessage(tr("error occured: %0").arg(enumToString(error)));
}

void DeviceConnection::peerVerifyError(const QSslError &error)
{
    qDebug() << error;
    emit logMessage(tr("ssl peer verify error"));
}

void DeviceConnection::sslErrors(const QList<QSslError> &errors)
{
    qDebug() << errors;
    emit logMessage(tr("ssl errors"));
}

// void DeviceConnection::preSharedKeyAuthenticationRequired(QSslPreSharedKeyAuthenticator *authenticator)
// {

// }

void DeviceConnection::alertSent(QSsl::AlertLevel level, QSsl::AlertType type, const QString &description)
{
    qDebug() << level << type << description;
    emit logMessage(tr("ssl alert sent level=%0 type=%1 description=%2").arg(enumToString(level)).arg(enumToString(type)).arg(description));
}

void DeviceConnection::alertReceived(QSsl::AlertLevel level, QSsl::AlertType type, const QString &description)
{
    qDebug() << level << type << description;
    emit logMessage(tr("ssl alert received level=%0 type=%1 description=%2").arg(enumToString(level)).arg(enumToString(type)).arg(description));
}

void DeviceConnection::handshakeInterruptedOnError(const QSslError &error)
{
    qDebug() << error;
    emit logMessage(tr("ssl handshake interrupted on error"));
}

void DeviceConnection::sendAuthInternal()
{
    auto hash2 = QCryptographicHash::hash(m_token1.toUtf8() + m_password.toUtf8(), QCryptographicHash::Sha256).toHex().toLower();

    const QString token3 = "hatschi";

    auto hash3 = QCryptographicHash::hash(token3.toUtf8() + m_token2.toUtf8() + hash2, QCryptographicHash::Sha256).toHex().toLower();

    sendMessage({
        { "type", "auth" },
        { "token3", token3 },
        { "hash", hash3 },
        { "requestId", "auth-request" }
    }, [this](const QString &type, const QVariantMap &message){
         authResponse(type, message);
    });
}

void DeviceConnection::authResponse(const QString &type, const QVariantMap &message)
{
    if (type == "authError")
    {
        m_password.clear();
        emit authError(message.value("message").toString());
    }
    else if (type == "authImpossible")
    {
        emit authImpossible();
    }
    else if (type == "authSuccess")
    {
        if (m_settings)
            m_settings->refreshSavedDevice(SavedDevice {
                .serial = m_serial,
                .manufacturer = m_manufacturer,
                .deviceType = m_deviceType,
                .friendlyName = m_friendlyName,
                .password = m_password
            });

        emit authSuccess();
    }
    else
    {
        emit authError(tr("unknown response type %0").arg(type));
    }
}
