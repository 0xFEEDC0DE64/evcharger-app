#pragma once

#include <QSettings>
#include <QtQml/qqmlregistration.h>

#include <vector>

struct SavedDevice
{
    QString serial;
    QString manufacturer;
    QString deviceType;
    QString friendlyName;
    QString password;
};

class AppSettings : public QSettings
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int numberOfAppInstances READ numberOfAppInstances WRITE setNumberOfAppInstances NOTIFY numberOfAppInstancesChanged FINAL)
    Q_PROPERTY(QString solalawebKey READ solalawebKey WRITE setSolalawebKey NOTIFY solalawebKeyChanged FINAL)
    Q_PROPERTY(QString solalawebCert READ solalawebCert WRITE setSolalawebCert NOTIFY solalawebCertChanged FINAL)
    Q_PROPERTY(bool showSolalaweb READ showSolalaweb WRITE setShowSolalaweb NOTIFY showSolalawebChanged FINAL)

public:
    std::vector<SavedDevice> getSavedDevices();
    void saveSavedDevices(const std::vector<SavedDevice> &savedDevices);
    void refreshSavedDevice(SavedDevice &&savedDevice);
    void removeSavedDevice(const QString &serial);

    int numberOfAppInstances() const;
    void setNumberOfAppInstances(int numberOfAppInstances);

    QString solalawebKey() const;
    void setSolalawebKey(const QString &solalawebKey);
    Q_INVOKABLE bool loadSolalawebKey(const QString &url);

    QString solalawebCert() const;
    void setSolalawebCert(const QString &solalawebCert);
    Q_INVOKABLE bool loadSolalawebCert(const QString &url);

    bool showSolalaweb() const;
    void setShowSolalaweb(bool showSolalaweb);

signals:
    void numberOfAppInstancesChanged(int numberOfAppInstances);
    void solalawebKeyChanged(const QString &solalawebKey);
    void solalawebCertChanged(const QString &solalawebCert);
    void showSolalawebChanged(bool showSolalaweb);

private:
    mutable std::optional<int> m_numberOfAppInstances;
    mutable std::optional<QString> m_solalawebKey;
    mutable std::optional<QString> m_solalawebCert;
    mutable std::optional<bool> m_showSolalaweb;
};
