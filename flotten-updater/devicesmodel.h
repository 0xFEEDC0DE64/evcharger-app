#pragma once

#include <QAbstractTableModel>

#include <vector>
#include <memory>

class QSslKey;
class QSslCertificate;

class FlottenUpdaterSettings;
class DeviceConnection;

class DevicesModel : public QAbstractTableModel
{
    Q_OBJECT

    using base = QAbstractTableModel;

public:
    explicit DevicesModel(FlottenUpdaterSettings &settings, const QByteArray &username,
                           const QByteArray &password, QObject *parent = nullptr);
    ~DevicesModel() override;

    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    bool removeRows(int row, int count, const QModelIndex &parent) override;

    bool addClient(const QString &serial);

    std::shared_ptr<DeviceConnection> getDevice(QModelIndex index);
    std::shared_ptr<const DeviceConnection> getDevice(QModelIndex index) const;

    void addCustomColumn(const QString &apiKey);
    bool customColumnRemovable(int section);
    void removeCustomColumn(int section);

    QStringList serials() const;

public slots:
    void connectAll();
    void disconnectAll();

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
    FlottenUpdaterSettings &m_settings;
    const QByteArray m_username;
    const QByteArray m_password;
    void columnChanged(int column, const QList<int> &roles = QList<int>());

    std::vector<std::shared_ptr<DeviceConnection>> m_devices;

    QStringList m_customColumns;
};
