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

public:
    std::vector<SavedDevice> getSavedDevices();
    void saveSavedDevices(const std::vector<SavedDevice> &savedDevices);
    void refreshSavedDevice(SavedDevice &&savedDevice);
    void removeSavedDevice(const QString &serial);

    int numberOfAppInstances() const;
    void setNumberOfAppInstances(int numberOfAppInstances);

signals:
    void numberOfAppInstancesChanged(int numberOfAppInstances);

private:
    mutable std::optional<int> m_numberOfAppInstances;
};
