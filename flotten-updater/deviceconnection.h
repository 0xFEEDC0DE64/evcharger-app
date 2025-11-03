#pragma once

#include <QObject>
#include <QWebSocket>
#include <QBrush>
#include <QVariantMap>

class QSslKey;
class QSslCertificate;
class QJsonObject;

class DeviceConnection : public QObject
{
    Q_OBJECT

public:
    explicit DeviceConnection(const QByteArray &username, const QByteArray &password, QString &&serial, QObject *parent = nullptr);
    explicit DeviceConnection(const QByteArray &username, const QByteArray &password, const QString &serial, QObject *parent = nullptr);

    void start();
    void stop();

    const QString &serial() const { return m_serial; }

    QString wsStatusText() const;
    QBrush wsStatusBackground() const;

    QString statusText() const;
    QBrush statusBackground() const;

    QString variantText() const;
    QBrush variantBackground() const;

    QString isGoText() const;
    QBrush isGoBackground() const;

    QString isAustralienText() const;
    QBrush isAustralienBackground() const;

    QString resetCardText() const;
    QBrush resetCardBackground() const;

    QString connectedWifiText() const;

    QString projectText() const;

    QString versionText() const;

    QString idfVersionText() const;

    QString updateText() const;
    QBrush updateBackground() const;

    std::optional<qulonglong> uptime() const;
    QString uptimeText() const;

    QString currentPartition() const;

    std::optional<int> reboots() const;
    QString rebootsText() const;

    QString carStateText() const;

    std::optional<double> energy() const;
    QString energyText() const;

    QString livedataText() const;

    QVariant getApiKey(const QString &apiKey) const;

    void sendMessage(const QJsonDocument &doc);
    void sendMessage(const QJsonObject &obj);
    void sendMessage(const QString &msg);

    QString errorString() const;

signals:
    void connectedSignal();
    void disconnectedSignal();
    void errorOccurredSignal(QAbstractSocket::SocketError error);

    void responseReceived(const QString &requestId, const QJsonObject &msg);

    void wsStatusChanged();
    void statusChanged();
    void variantChanged();
    void isGoChanged();
    void isAustralienChanged();
    void resetCardChanged();
    void connectedWifiChanged();
    void projectChanged();
    void versionChanged();
    void idfVersionChanged();
    void updateChanged();
    void uptimeChanged();
    void currentPartitionChanged();
    void rebootsChanged();
    void carStateChanged();
    void energyChanged();
    void livedataChanged();
    void apiKeyChanged(const QString &apiKey);

private:
    void init();
    void maintainStatus(const QJsonObject &msg, bool forceChange);

private slots:
    void connected();
    void disconnected();
    void stateChanged(QAbstractSocket::SocketState state);
    void textMessageReceived(const QString &message);
    void binaryMessageReceived(const QByteArray &message);
    void errorOccurred(QAbstractSocket::SocketError error);
    void peerVerifyError(const QSslError &error);
    void sslErrors(const QList<QSslError> &errors);
    void alertReceived(QSsl::AlertLevel level, QSsl::AlertType type, const QString &description);
    void handshakeInterruptedOnError(const QSslError &error);

private:
    const QString m_serial;
    const QByteArray m_username;
    const QByteArray m_password;

    enum Status {
        Unknown,
        Ok,
        Offline
    };
    Status m_status{Status::Unknown};

    QWebSocket m_websocket;

    QVariantMap m_fullStatus;
    bool m_receivedDelta{false};
};
