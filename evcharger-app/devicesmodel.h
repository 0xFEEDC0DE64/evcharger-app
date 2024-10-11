#pragma once

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>

#include <vector>

#include <qzeroconf.h>

#include "appsettings.h"

class DevicesModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(AppSettings* settings READ settings WRITE setSettings NOTIFY settingsChanged FINAL)

public:
    explicit DevicesModel(QObject *parent = nullptr);
    Q_INVOKABLE void start();

    AppSettings *settings() { return m_settings; }
    const AppSettings *settings() const { return m_settings; }
    void setSettings(AppSettings *settings);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QMap<int, QVariant> itemData(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool removeRows(int row, int count, const QModelIndex &parent) override;

signals:
    void settingsChanged(AppSettings *settings);

private slots:
    void error(QZeroConf::error_t error);
    void serviceAdded(QZeroConfService service);
    void serviceUpdated(QZeroConfService service);
    void serviceRemoved(QZeroConfService service);

private:
    AppSettings *m_settings{};

    struct FoundDevice : public SavedDevice
    {
        bool saved{};
        QString hostName;
        QHostAddress ip;
    };

    std::vector<FoundDevice> m_foundDevices;

    QZeroConf m_zeroConf;
};
