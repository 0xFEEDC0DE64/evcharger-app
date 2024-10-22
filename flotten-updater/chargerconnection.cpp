#include "chargerconnection.h"

#include <QSslConfiguration>
#include <QSslCertificate>
#include <QSslKey>
#include <QFile>
#include <QDebug>
#include <QMetaEnum>
#include <QColor>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include <utility>

#include "chargersmodel.h"

namespace {
const constexpr QColor red{255, 150, 150};
const constexpr QColor yellow{255, 255, 150};
const constexpr QColor green{150, 255, 150};
const constexpr QColor cyan{150, 255, 255};
const constexpr QColor blue{150, 150, 255};
const constexpr QColor magenta{255, 150, 255};
}

ChargerConnection::ChargerConnection(const QSslKey &key, const QSslCertificate &cert, QString &&serial, QObject *parent) :
    QObject{parent},
    m_serial(std::move(serial)),
    m_key{key},
    m_cert{cert}
{
    init();
}

ChargerConnection::ChargerConnection(const QSslKey &key, const QSslCertificate &cert, const QString &serial, QObject *parent) :
    QObject{parent},
    m_serial(serial),
    m_key{key},
    m_cert{cert}
{
    init();
}

void ChargerConnection::start()
{
    const QUrl url{QString("wss://solalaweb.com/%0").arg(m_serial)};
    qDebug() << url;
    m_websocket.open(url);
}

void ChargerConnection::stop()
{
    m_websocket.close();
}

QString ChargerConnection::wsStatusText() const
{
    return QMetaEnum::fromType<QAbstractSocket::SocketState>().valueToKey(m_websocket.state());
}

QBrush ChargerConnection::wsStatusBackground() const
{
    switch (m_websocket.state())
    {
    case QAbstractSocket::UnconnectedState: return red;
    case QAbstractSocket::HostLookupState:
    case QAbstractSocket::ConnectingState: return yellow;
    case QAbstractSocket::ConnectedState: return green;
    case QAbstractSocket::ClosingState: return red;
    }
    return {};
}

QString ChargerConnection::statusText() const
{
    switch (m_status)
    {
    case Status::Unknown: return tr("Unknown");
    case Status::Ok: return tr("Ok");
    case Status::Offline: return tr("Offline");
    }

    return QString::number(std::to_underlying(m_status));
}

QBrush ChargerConnection::statusBackground() const
{
    switch (m_status)
    {
    case Status::Unknown: return yellow;
    case Status::Ok: return green;
    case Status::Offline: return red;
    }
    return {};
}

QString ChargerConnection::variantText() const
{
    if (!m_fullStatus.contains("var"))
        return {};

    return m_fullStatus.value("var").toString();
}

QBrush ChargerConnection::variantBackground() const
{
    if (!m_fullStatus.contains("var"))
        return {};

    switch (m_fullStatus.value("var").toInt())
    {
    case 11: return blue;
    case 22: return yellow;
    }
    return red;
}

QString ChargerConnection::isGoText() const
{
    if (!m_fullStatus.contains("isgo"))
        return {};

    return m_fullStatus.value("isgo").toBool() ? "yes" : "no";
}

QBrush ChargerConnection::isGoBackground() const
{
    if (!m_fullStatus.contains("isgo"))
        return {};

    return m_fullStatus.value("isgo").toBool() ? blue : yellow;
}

QString ChargerConnection::isAustralienText() const
{
    if (!m_fullStatus.contains("aus"))
        return {};

    return m_fullStatus.value("aus").toBool() ? "yes" : "no";
}

QBrush ChargerConnection::isAustralienBackground() const
{
    if (!m_fullStatus.contains("aus"))
        return {};

    return m_fullStatus.value("aus").toBool() ? yellow : blue;
}

QString ChargerConnection::resetCardText() const
{
    if (!m_fullStatus.contains("frci"))
        return {};

    return m_fullStatus.value("frci").toBool() ? "yes" : "no";
}

QBrush ChargerConnection::resetCardBackground() const
{
    if (!m_fullStatus.contains("frci"))
        return {};

    return m_fullStatus.value("frci").toBool() ? green : red;
}

QString ChargerConnection::connectedWifiText() const
{
    if (!m_fullStatus.contains("ccw"))
        return {};

    const auto &apd = m_fullStatus.value("ccw").toJsonObject();
    if (!apd.contains("ssid"))
        return {};

    return apd.value("ssid").toString();
}

QString ChargerConnection::projectText() const
{
    if (!m_fullStatus.contains("apd"))
        return {};

    const auto &apd = m_fullStatus.value("apd").toJsonObject();
    if (!apd.contains("project_name"))
        return {};

    return apd.value("project_name").toString();
}

QString ChargerConnection::versionText() const
{
    if (!m_fullStatus.contains("apd"))
        return {};

    const auto &apd = m_fullStatus.value("apd").toJsonObject();
    if (!apd.contains("version"))
        return {};

    return apd.value("version").toString();
}

QString ChargerConnection::idfVersionText() const
{
    if (!m_fullStatus.contains("apd"))
        return {};

    const auto &apd = m_fullStatus.value("apd").toJsonObject();
    if (!apd.contains("idf_ver"))
        return {};

    return apd.value("idf_ver").toString();
}

QString ChargerConnection::updateText() const
{
    if (!m_fullStatus.contains("ocs"))
        return {};

    const QStringList updateStates { tr("Idle"), tr("Updating"), tr("Failed"), tr("Succeeded"), tr("NotReady"), tr("Verifying") };
    const auto ocs = m_fullStatus.value("ocs").toInt();
    if (ocs >= 0 && ocs < updateStates.size())
    {
        if (ocs == 1)
        {
            std::optional<int> progress;
            if (m_fullStatus.contains("ocp"))
                progress = m_fullStatus.value("ocp").toInt();
            std::optional<int> total;
            if (m_fullStatus.contains("ocl"))
                total = m_fullStatus.value("ocl").toInt();
            if (progress && total)
                return (tr("%0 %1%").arg(updateStates.at(ocs)).arg(*progress ? *progress * 100 / *total : 0));
            else if (progress)
                return tr("%0 %1/?").arg(updateStates.at(ocs)).arg(*progress);
            else if (total)
                return tr("%0 ?/%1").arg(updateStates.at(ocs)).arg(*total);
        }
        return updateStates.at(ocs);
    }
    return QString::number(ocs);
}

QBrush ChargerConnection::updateBackground() const
{
    if (!m_fullStatus.contains("ocs"))
        return {};

    const auto ocs = m_fullStatus.value("ocs").toInt();
    switch (ocs)
    {
    case 1: return yellow;
    case 2: return red;
    case 3: return green;
    case 4: return red;
    case 5: return yellow;
    }

    return {};
}

std::optional<qulonglong> ChargerConnection::uptime() const
{
    if (!m_fullStatus.contains("rbt"))
        return {};

    return m_fullStatus.value("rbt").toULongLong();
}

QString ChargerConnection::uptimeText() const
{
    if (!m_fullStatus.contains("rbt"))
        return {};

    return QString::number(m_fullStatus.value("rbt").toULongLong());
}

QString ChargerConnection::currentPartition() const
{
    if (!m_fullStatus.contains("otap"))
        return {};

    const auto &otap = m_fullStatus.value("otap").toJsonObject();
    if (!otap.contains("label"))
        return {};

    return otap.value("label").toString();
}

std::optional<int> ChargerConnection::reboots() const
{
    if (!m_fullStatus.contains("rbc"))
        return {};

    return m_fullStatus.value("rbc").toInt();
}

QString ChargerConnection::rebootsText() const
{
    if (!m_fullStatus.contains("rbc"))
        return {};

    return QString::number(m_fullStatus.value("rbc").toInt());
}

QString ChargerConnection::carStateText() const
{
    if (!m_fullStatus.contains("car"))
        return {};

    const QStringList carStates { tr("Unknown"), tr("Idle"), tr("Charging"), tr("WaitCar"), tr("Complete"), tr("Error") };
    const auto car = m_fullStatus.value("car").toInt();
    if (car >= 0 && car < carStates.size())
        return carStates.at(car);
    return QString::number(car);
}

std::optional<double> ChargerConnection::energy() const
{
    if (!m_fullStatus.contains("eto"))
        return {};

    return m_fullStatus.value("eto").toDouble();
}

QString ChargerConnection::energyText() const
{
    if (!m_fullStatus.contains("eto"))
        return {};

    return QString("%0kWh").arg(m_fullStatus.value("eto").toDouble() / 1000.);
}

QString ChargerConnection::livedataText() const
{
    if (!m_fullStatus.contains("nrg"))
        return {};

    const auto nrg = m_fullStatus.value("nrg").toList();
    if (nrg.size() > 3)
        return QString{"%0V %1V %2V %3V"}
            .arg(nrg.at(0).toDouble())
            .arg(nrg.at(1).toDouble())
            .arg(nrg.at(2).toDouble())
            .arg(nrg.at(3).toDouble());
    return {};
}

QVariant ChargerConnection::getApiKey(const QString &apiKey) const
{
    return m_fullStatus.value(apiKey);
}

void ChargerConnection::sendMessage(const QJsonDocument &doc)
{
    sendMessage(QString::fromUtf8(doc.toJson()));
}

void ChargerConnection::sendMessage(const QJsonObject &obj)
{
    sendMessage(QJsonDocument{obj});
}

void ChargerConnection::sendMessage(const QString &msg)
{
    qDebug() << msg << m_websocket.errorString();
    if (const auto written = m_websocket.sendTextMessage(msg); written != msg.size())
        qCritical() << "sending message failed" << written << "(expected:" << msg.size() << ')';
}

void ChargerConnection::init()
{
    if (auto model = qobject_cast<ChargersModel*>(parent()))
    {
        connect(this, &ChargerConnection::wsStatusChanged, model, &ChargersModel::wsStatusChanged);
        connect(this, &ChargerConnection::statusChanged, model, &ChargersModel::statusChanged);
        connect(this, &ChargerConnection::variantChanged, model, &ChargersModel::variantChanged);
        connect(this, &ChargerConnection::isGoChanged, model, &ChargersModel::isGoChanged);
        connect(this, &ChargerConnection::isAustralienChanged, model, &ChargersModel::isAustralienChanged);
        connect(this, &ChargerConnection::resetCardChanged, model, &ChargersModel::resetCardChanged);
        connect(this, &ChargerConnection::connectedWifiChanged, model, &ChargersModel::connectedWifiChanged);
        connect(this, &ChargerConnection::projectChanged, model, &ChargersModel::projectChanged);
        connect(this, &ChargerConnection::versionChanged, model, &ChargersModel::versionChanged);
        connect(this, &ChargerConnection::idfVersionChanged, model, &ChargersModel::idfVersionChanged);
        connect(this, &ChargerConnection::updateChanged, model, &ChargersModel::updateChanged);
        connect(this, &ChargerConnection::uptimeChanged, model, &ChargersModel::uptimeChanged);
        connect(this, &ChargerConnection::currentPartitionChanged, model, &ChargersModel::currentPartitionChanged);
        connect(this, &ChargerConnection::rebootsChanged, model, &ChargersModel::rebootsChanged);
        connect(this, &ChargerConnection::carStateChanged, model, &ChargersModel::carStateChanged);
        connect(this, &ChargerConnection::energyChanged, model, &ChargersModel::energyChanged);
        connect(this, &ChargerConnection::livedataChanged, model, &ChargersModel::livedataChanged);
        connect(this, &ChargerConnection::apiKeyChanged, model, &ChargersModel::apiKeyChanged);
    }
    else
        qWarning() << "unexpected parent";

    {
        auto sslConfig = m_websocket.sslConfiguration();
        sslConfig.setPeerVerifyMode(QSslSocket::VerifyNone);
        //sslConfig.setPeerVerifyMode(QSslSocket::VerifyPeer);
        {
            auto caCerts = QSslCertificate::fromPath(":/goe-root-ca.pem");
            if (caCerts.empty())
                qFatal("could not parse root ca");
            for (const auto &caCert : std::as_const(caCerts))
                qDebug() << caCert.issuerDisplayName();
            sslConfig.setCaCertificates(std::move(caCerts));
        }
        sslConfig.setPrivateKey(m_key);
        sslConfig.setLocalCertificate(m_cert);
        m_websocket.setSslConfiguration(sslConfig);
        m_websocket.ignoreSslErrors();
    }

    connect(&m_websocket, &QWebSocket::connected, this, &ChargerConnection::connected);
    connect(&m_websocket, &QWebSocket::disconnected, this, &ChargerConnection::disconnected);
    connect(&m_websocket, &QWebSocket::stateChanged, this, &ChargerConnection::stateChanged);
    connect(&m_websocket, &QWebSocket::textMessageReceived, this, &ChargerConnection::textMessageReceived);
    connect(&m_websocket, &QWebSocket::binaryMessageReceived, this, &ChargerConnection::binaryMessageReceived);
    connect(&m_websocket, &QWebSocket::errorOccurred, this, &ChargerConnection::errorOccurred);
    connect(&m_websocket, &QWebSocket::peerVerifyError, this, &ChargerConnection::peerVerifyError);
    connect(&m_websocket, &QWebSocket::sslErrors, this, &ChargerConnection::sslErrors);
    connect(&m_websocket, &QWebSocket::alertReceived, this, &ChargerConnection::alertReceived);
    connect(&m_websocket, &QWebSocket::handshakeInterruptedOnError, this, &ChargerConnection::handshakeInterruptedOnError);
}

void ChargerConnection::maintainStatus(const QJsonObject &msg, bool forceChange)
{
    bool variantChanged{forceChange};
    bool isGoChanged{forceChange};
    bool isAustralienChanged{forceChange};
    bool resetCardChanged{forceChange};
    bool connectedWifiChanged{forceChange};
    bool versionChanged{forceChange};
    bool updateChanged{forceChange};
    bool uptimeChanged{forceChange};
    bool currentPartitionChanged{forceChange};
    bool rebootsChanged{forceChange};
    bool carStateChanged{forceChange};
    bool energyChanged{forceChange};
    bool livedataChanged{forceChange};

    const auto status = msg.value("status").toObject();
    for (auto iter = std::cbegin(status); iter != std::cend(status); iter++)
    {
        m_fullStatus[iter.key()] = iter.value().toVariant();

        if (iter.key() == "var")
            variantChanged = true;
        else if (iter.key() == "isgo")
            isGoChanged = true;
        else if (iter.key() == "aus")
            isAustralienChanged = true;
        else if (iter.key() == "frci")
            resetCardChanged = true;
        else if (iter.key() == "ccw")
            connectedWifiChanged = true;
        else if (iter.key() == "apd")
            versionChanged = true;
        else if (iter.key() == "ocs" || iter.key() == "ocp" || iter.key() == "ocl")
            updateChanged = true;
        else if (iter.key() == "rbt")
            uptimeChanged = true;
        else if (iter.key() == "otap")
            currentPartitionChanged = true;
        else if (iter.key() == "rbc")
            rebootsChanged = true;
        else if (iter.key() == "car")
            carStateChanged = true;
        else if (iter.key() == "eto")
            energyChanged = true;
        else if (iter.key() == "nrg")
            livedataChanged = true;

        emit apiKeyChanged(iter.key());
    }

    if (variantChanged)
        emit this->variantChanged();
    if (isGoChanged)
        emit this->isGoChanged();
    if (isAustralienChanged)
        emit this->isAustralienChanged();
    if (resetCardChanged)
        emit this->resetCardChanged();
    if (connectedWifiChanged)
        emit this->connectedWifiChanged();
    if (versionChanged)
    {
        emit this->projectChanged();
        emit this->versionChanged();
        emit this->idfVersionChanged();
    }
    if (updateChanged)
        emit this->updateChanged();
    if (uptimeChanged)
        emit this->uptimeChanged();
    if (currentPartitionChanged)
        emit this->currentPartitionChanged();
    if (rebootsChanged)
        emit this->rebootsChanged();
    if (carStateChanged)
        emit this->carStateChanged();
    if (energyChanged)
        emit this->energyChanged();
    if (livedataChanged)
        emit this->livedataChanged();
}

void ChargerConnection::connected()
{
    qDebug() << "called";
}

void ChargerConnection::disconnected()
{
    qDebug() << "called";
}

void ChargerConnection::stateChanged(QAbstractSocket::SocketState state)
{
//    qDebug() << "called" << state;

    if (state != QAbstractSocket::ConnectedState)
    {
        if (m_status != Status::Unknown)
        {
            m_status = Status::Unknown;
            emit statusChanged();
        }
    }

    emit wsStatusChanged();
}

void ChargerConnection::textMessageReceived(const QString &message)
{
//    qDebug() << "called" << message;

    QJsonParseError error;
    const auto doc = QJsonDocument::fromJson(message.toUtf8(), &error);
    if (error.error != QJsonParseError::NoError)
    {
        qWarning() << m_serial << "could not parse json:" << error.errorString();
        return;
    }

    if (!doc.isObject())
    {
        qWarning() << m_serial << "json is not an object";
        return;
    }

    const auto msgObj = doc.object();

    if (!msgObj.contains("type"))
    {
        qWarning() << "msg does not contain a type";
        return;
    }

    const auto typeVal = msgObj.value("type");

    if (!typeVal.isString())
    {
        qWarning() << "msg type is not a string";
        return;
    }

    const auto type = typeVal.toString();

    bool response{};
    if (msgObj.contains("requestId"))
    {
        response = true;

        qDebug() << "response to a request" << message;

        emit responseReceived(msgObj.value("requestId").toString(), msgObj);
    }

    if (type == "hello")
    {
//        qDebug() << "hello received" << msgObj;
        m_status = Status::Ok;
        emit statusChanged();
    }
    else if (type == "offline")
    {
//        qDebug() << "offline received" << msgObj;
        m_status = Status::Offline;
        emit statusChanged();
    }
    else if (type == "fullStatus")
    {
        bool forceChange{false};

        if (m_receivedDelta)
        {
            m_receivedDelta = false;
            m_fullStatus.clear();
            forceChange = true;
        }

        maintainStatus(msgObj, forceChange);
    }
    else if (type == "deltaStatus")
    {
        m_receivedDelta = true;

        maintainStatus(msgObj, false);
    }
    else if (!response)
        qWarning() << "unknown message type" << msgObj;
}

void ChargerConnection::binaryMessageReceived(const QByteArray &message)
{
    qDebug() << "called" << message;
}

void ChargerConnection::errorOccurred(QAbstractSocket::SocketError error)
{
    qDebug() << "called" << QMetaEnum::fromType<QAbstractSocket::SocketError>().valueToKey(error) << m_websocket.errorString();
}

void ChargerConnection::peerVerifyError(const QSslError &error)
{
    qDebug() << "called" << error;
}

void ChargerConnection::sslErrors(const QList<QSslError> &errors)
{
    qDebug() << "called" << errors;
}

void ChargerConnection::alertReceived(QSsl::AlertLevel level, QSsl::AlertType type, const QString &description)
{
    qDebug() << "called" << std::to_underlying(level) << std::to_underlying(type) << description;
}

void ChargerConnection::handshakeInterruptedOnError(const QSslError &error)
{
    qDebug() << "called" << error;
}
