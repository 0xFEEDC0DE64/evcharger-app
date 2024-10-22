#pragma once

#include <QAbstractTableModel>

#include <vector>
#include <memory>

class QSslKey;
class QSslCertificate;

class FlottenUpdaterSettings;
class ChargerConnection;

class ChargersModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit ChargersModel(FlottenUpdaterSettings &settings, const QSslKey &key,
                           const QSslCertificate &cert, QObject *parent = nullptr);
    ~ChargersModel() override;

    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

    void addClient(const QString &serial);

    std::shared_ptr<ChargerConnection> getCharger(QModelIndex index);
    std::shared_ptr<const ChargerConnection> getCharger(QModelIndex index) const;

    void addCustomColumn(const QString &apiKey);
    bool customColumnRemovable(int section);
    void removeCustomColumn(int section);

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
    const QSslKey &m_key;
    const QSslCertificate &m_cert;
    void columnChanged(int column, const QList<int> &roles = QList<int>());

    std::vector<std::shared_ptr<ChargerConnection>> m_chargers;

    QStringList m_customColumns;
};
