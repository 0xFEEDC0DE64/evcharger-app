#include "devicesmodel.h"

#include <QDebug>
#include <QBrush>
#include <QJsonDocument>

#include <algorithm>
#include <iterator>

#include "deviceconnection.h"
#include "flottenupdatersettings.h"

namespace {
enum {
    ColumnSerial,
    ColumnWsStatus,
    ColumnStatus,
    ColumnVariant,
    ColumnIsGo,
    ColumnIsAustralien,
    ColumnResetCard,
    ColumnConnectedWifi,
    ColumnProject,
    ColumnVersion,
    ColumnIdfVersion,
    ColumnUpdate,
    ColumnReboots,
    ColumnUptime,
    ColumnCurrentPartition,
    ColumnCarState,
    ColumnEnergy,
    ColumnLivedata,
    NumberOfColumns
};
}

DevicesModel::DevicesModel(FlottenUpdaterSettings &settings, const QSslKey &key,
                             const QSslCertificate &cert, QObject *parent) :
    QAbstractTableModel{parent},
    m_settings{settings},
    m_key{key},
    m_cert{cert},
    m_customColumns{settings.customColumns()}
{
    for (const auto &serial : m_settings.serials())
    {
        if (std::none_of(std::cbegin(m_devices), std::cend(m_devices), [&serial](auto &ptr){
            return ptr->serial() == serial;
        }))
        m_devices.emplace_back(std::make_shared<DevicesConnection>(m_key, m_cert, serial, this));
    }
}

DevicesModel::~DevicesModel() = default;

int DevicesModel::rowCount(const QModelIndex &parent) const
{
    return m_devices.size();
}

int DevicesModel::columnCount(const QModelIndex &parent) const
{
    return NumberOfColumns + m_customColumns.size();
}

QVariant DevicesModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_devices.size())
    {
        qWarning() << "row out of bounds";
        return {};
    }

    const DevicesConnection &device = **std::next(std::begin(m_devices), index.row());

    switch (index.column())
    {
    case ColumnSerial:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.serial();
        }
        return {};
    case ColumnWsStatus:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.wsStatusText();
        case Qt::BackgroundRole:
            return device.wsStatusBackground();
        }
        return {};
    case ColumnStatus:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.statusText();
        case Qt::BackgroundRole:
            return device.statusBackground();
        }
        return {};
    case ColumnVariant:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.variantText();
        case Qt::BackgroundRole:
            return device.variantBackground();
        }
        return {};
    case ColumnIsGo:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.isGoText();
        case Qt::BackgroundRole:
            return device.isGoBackground();
        }
        return {};
    case ColumnIsAustralien:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.isAustralienText();
        case Qt::BackgroundRole:
            return device.isAustralienBackground();
        }
        return {};
    case ColumnResetCard:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.resetCardText();
        case Qt::BackgroundRole:
            return device.resetCardBackground();
        }
        return {};
    case ColumnConnectedWifi:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.connectedWifiText();
        }
        return {};
    case ColumnProject:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.projectText();
        }
        return {};
    case ColumnVersion:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.versionText();
        }
        return {};
    case ColumnIdfVersion:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.idfVersionText();
        }
        return {};
    case ColumnUpdate:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.updateText();
        case Qt::BackgroundRole:
            return device.updateBackground();
        }
        return {};
    case ColumnUptime:
        switch (role)
        {
        case Qt::DisplayRole:
            return device.uptimeText();
        case Qt::EditRole:
            if (const auto uptime = device.uptime(); uptime)
                return *uptime;
        }
        return {};
    case ColumnCurrentPartition:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.currentPartition();
        }
        return {};
    case ColumnReboots:
        switch (role)
        {
        case Qt::DisplayRole:
            return device.rebootsText();
        case Qt::EditRole:
            if (const auto reboots = device.reboots(); reboots)
                return *reboots;
        }
        return {};
    case ColumnCarState:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.carStateText();
        }
        return {};
    case ColumnEnergy:
        switch (role)
        {
        case Qt::DisplayRole:
            return device.energyText();
        case Qt::EditRole:
            if (const auto energy = device.energy(); energy)
                return *energy;
        }
        return {};
    case ColumnLivedata:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return device.livedataText();
        }
        return {};
    }

    if (index.column() >= NumberOfColumns && index.column() - NumberOfColumns < m_customColumns.size())
        switch (role)
        {
        case Qt::DisplayRole:
        {
            auto variant = device.getApiKey(m_customColumns.at(index.column() - NumberOfColumns));
            auto str = variant.toString();
            if (str.isEmpty())
                str = QJsonDocument::fromVariant(variant).toJson(QJsonDocument::Compact);
            return str;
        }
        case Qt::EditRole:
            return device.getApiKey(m_customColumns.at(index.column() - NumberOfColumns));
        }

    return {};
}

QVariant DevicesModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole && role != Qt::EditRole)
        return {};

    switch (orientation)
    {
    case Qt::Horizontal:
        switch (section)
        {
        case ColumnSerial: return tr("Serial");
        case ColumnWsStatus: return tr("WS Status");
        case ColumnStatus: return tr("Status");
        case ColumnVariant: return tr("Variant");
        case ColumnIsGo: return tr("IsGo");
        case ColumnIsAustralien: return tr("IsAustralien");
        case ColumnResetCard: return tr("ResetCard");
        case ColumnConnectedWifi: return tr("ConnectedWifi");
        case ColumnProject: return tr("Project");
        case ColumnVersion: return tr("Version");
        case ColumnIdfVersion: return tr("IDF Version");
        case ColumnUpdate: return tr("Update");
        case ColumnReboots: return tr("Reboots");
        case ColumnUptime: return tr("Uptime");
        case ColumnCurrentPartition: return tr("Current Partition");
        case ColumnCarState: return tr("Car state");
        case ColumnEnergy: return tr("Energy");
        case ColumnLivedata: return tr("Livedata");
        }

        if (section >= NumberOfColumns && section - NumberOfColumns < m_customColumns.size())
            return m_customColumns[section - NumberOfColumns];

        return {};
    }

    return {};
}

bool DevicesModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || std::size_t(row) >= m_devices.size())
    {
        qWarning() << "unexpected row" << row;
        return false;
    }

    if (count < 0 || std::size_t(count) > m_devices.size() - row)
    {
        qWarning() << "unexpected row+count" << count << row;
        return false;
    }

    beginRemoveRows({}, row, row + count - 1);
    auto begin = std::next(std::begin(m_devices), row);
    auto end = std::next(begin, count);
    m_devices.erase(begin, end);
    endRemoveRows();

    return true;
}

void DevicesModel::addClient(const QString &serial)
{
    beginInsertRows({}, m_devices.size(), m_devices.size());

    auto clientPtr = std::make_shared<DevicesConnection>(m_key, m_cert, serial, this);
    auto client = clientPtr.get();
    m_devices.emplace_back(std::move(clientPtr));

    endInsertRows();

    client->start();
}

std::shared_ptr<DevicesConnection> DevicesModel::getDevice(QModelIndex index)
{
    Q_ASSERT(!index.parent().isValid());
    Q_ASSERT(index.row() >= 0 && index.row() < m_devices.size());
    auto device = m_devices.at(index.row());
    Q_ASSERT(device);
    return device;
}

std::shared_ptr<const DevicesConnection> DevicesModel::getDevice(QModelIndex index) const
{
    Q_ASSERT(!index.parent().isValid());
    return m_devices.at(index.row());
}

void DevicesModel::addCustomColumn(const QString &apiKey)
{
    beginInsertColumns({}, NumberOfColumns + m_customColumns.size(), NumberOfColumns + m_customColumns.size());
    m_customColumns.push_back(apiKey);
    endInsertColumns();
    m_settings.setCustomColumns(m_customColumns);
}

bool DevicesModel::customColumnRemovable(int section)
{
    return section >= NumberOfColumns && section - NumberOfColumns < m_customColumns.size();
}

void DevicesModel::removeCustomColumn(int section)
{
    if (section < NumberOfColumns || section - NumberOfColumns >= m_customColumns.size())
        return;

    beginRemoveColumns({}, section, section);
    m_customColumns.erase(std::next(std::begin(m_customColumns), section - NumberOfColumns));
    endRemoveColumns();
    m_settings.setCustomColumns(m_customColumns);
}

QStringList DevicesModel::serials() const
{
    QStringList serials;

    serials.resize(m_devices.size());

    std::transform(std::cbegin(m_devices), std::cend(m_devices),
                   std::begin(serials), [](const auto &device){ return device->serial(); });

    return serials;
}

void DevicesModel::connectAll()
{
    for (auto &device : m_devices)
        device->start();
}

void DevicesModel::disconnectAll()
{
    for (auto &device : m_devices)
        device->stop();
}

void DevicesModel::wsStatusChanged()
{
    columnChanged(ColumnWsStatus, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::statusChanged()
{
    columnChanged(ColumnStatus, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::variantChanged()
{
    columnChanged(ColumnVariant, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::isGoChanged()
{
    columnChanged(ColumnIsGo, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::isAustralienChanged()
{
    columnChanged(ColumnIsAustralien, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::resetCardChanged()
{
    columnChanged(ColumnResetCard, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::connectedWifiChanged()
{
    columnChanged(ColumnConnectedWifi, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::projectChanged()
{
    columnChanged(ColumnProject, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::versionChanged()
{
    columnChanged(ColumnVersion, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::idfVersionChanged()
{
    columnChanged(ColumnIdfVersion, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::updateChanged()
{
    columnChanged(ColumnUpdate, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void DevicesModel::uptimeChanged()
{
    columnChanged(ColumnUptime, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::currentPartitionChanged()
{
    columnChanged(ColumnCurrentPartition, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::rebootsChanged()
{
    columnChanged(ColumnReboots, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::carStateChanged()
{
    columnChanged(ColumnCarState, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::energyChanged()
{
    columnChanged(ColumnEnergy, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::livedataChanged()
{
    columnChanged(ColumnLivedata, {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::apiKeyChanged(const QString &apiKey)
{
    for (auto iter = std::cbegin(m_customColumns); iter != std::cend(m_customColumns); iter++)
        if (*iter == apiKey)
            columnChanged(NumberOfColumns + std::distance(std::cbegin(m_customColumns), iter), {Qt::DisplayRole, Qt::EditRole});
}

void DevicesModel::columnChanged(int column, const QList<int> &roles)
{
    auto device = qobject_cast<DevicesConnection*>(sender());
    if (!device)
    {
        qWarning() << "unknown sender" << sender();
        return;
    }

    auto iter = std::find_if(std::cbegin(m_devices), std::cend(m_devices), [&device](const std::shared_ptr<DevicesConnection> &ptr){ return device == ptr.get(); });
    if (iter == std::cend(m_devices))
    {
        qWarning() << "unknown sender" << device;
        for (const auto &device : m_devices)
            qDebug() << device.get();
        return;
    }

    auto row = std::distance(std::cbegin(m_devices), iter);

    auto index = createIndex(row, column);
    emit dataChanged(index, index, roles);
}
