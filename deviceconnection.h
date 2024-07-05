#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

#include <QString>
#include <QWebSocket>
#include <QVariantMap>

#include "appsettings.h"

class DeviceConnection : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(AppSettings* settings READ settings WRITE setSettings NOTIFY settingsChanged FINAL)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged FINAL)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged FINAL)

    using callback_t = std::function<void(const QString &, const QVariantMap&)>;

public:
    explicit DeviceConnection(QObject *parent = nullptr);

    AppSettings *settings() { return m_settings; }
    const AppSettings *settings() const { return m_settings; }
    void setSettings(AppSettings *settings) { if (m_settings == settings) return; emit settingsChanged(m_settings = settings); }

    QString url() const { return m_url; }
    void setUrl(const QString &url);

    QString password() const { return m_password; }
    void setPassword(const QString &password);

    void messageReceived(const QVariant &variant);

    void sendMessage(QVariantMap variant, callback_t &&callback);

    const QVariantMap &getFullStatus() { return m_fullStatus; }

    QString generateRequestId();

public slots:
    void sendMessage(const QVariantMap &variant);
    void sendAuth(const QString &password);

signals:
    void settingsChanged(AppSettings *settings);
    void urlChanged(const QString &url);
    void passwordChanged(const QString &password);

    void logMessage(const QString &message);

    void responseReceived(const QString &requestId, const QVariantMap &message);

    void authRequired();
    void authError(const QString &message);
    void authImpossible();
    void authSuccess();

    void fullStatusReceived();
    void valueChanged(const QString &key, const QVariant &value);

private slots:
    void connected();
    void disconnected();
    void stateChanged(QAbstractSocket::SocketState state);
    void textMessageReceived(const QString &message);
    void binaryMessageReceived(QByteArray message);
    void errorOccurred(QAbstractSocket::SocketError error);

    void peerVerifyError(const QSslError &error);
    void sslErrors(const QList<QSslError> &errors);
    // void preSharedKeyAuthenticationRequired(QSslPreSharedKeyAuthenticator *authenticator);
    void alertSent(QSsl::AlertLevel level, QSsl::AlertType type, const QString &description);
    void alertReceived(QSsl::AlertLevel level, QSsl::AlertType type, const QString &description);
    void handshakeInterruptedOnError(const QSslError &error);

private:
    void sendAuthInternal();
    void authResponse(const QString &type, const QVariantMap &message);

    AppSettings *m_settings{};

    QString m_url;

    QWebSocket m_websocket;

    int m_requestId{};

    QString m_serial;
    bool m_secured{};
    QString m_manufacturer;
    QString m_deviceType;
    QString m_friendlyName;

    QString m_token1;
    QString m_token2;

    QString m_password;

    QHash<QString, callback_t> m_callbacks;

    QVariantMap m_fullStatus;
};
