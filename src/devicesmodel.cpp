#include "devicesmodel.h"

enum {
    SerialRole = Qt::UserRole,
    ManufacturerRole,
    DeviceTypeRole,
    FriendlyNameRole,
    PasswordRole,
    SavedRole,
    HostNameRole,
    IpRole
};

DevicesModel::DevicesModel(QObject *parent) :
    QAbstractListModel{parent}
{
    connect(&m_zeroConf, &QZeroConf::error, this, &DevicesModel::error);
    connect(&m_zeroConf, &QZeroConf::serviceAdded, this, &DevicesModel::serviceAdded);
    connect(&m_zeroConf, &QZeroConf::serviceUpdated, this, &DevicesModel::serviceUpdated);
    connect(&m_zeroConf, &QZeroConf::serviceRemoved, this, &DevicesModel::serviceRemoved);
}

void DevicesModel::start()
{
    qDebug() << "start() called";
    m_zeroConf.startBrowser("_http._tcp");
}

void DevicesModel::setSettings(AppSettings *settings)
{
    if (m_settings == settings)
        return;

    m_settings = settings;

    beginResetModel();

    if (m_settings)
        for (auto &device : m_settings->getSavedDevices())
            m_foundDevices.emplace_back(FoundDevice{std::move(device), true});

    endResetModel();
}

int DevicesModel::rowCount(const QModelIndex &parent) const
{
    return m_foundDevices.size();
}

QVariant DevicesModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_foundDevices.size())
    {
        qWarning() << "invalid row" << index.row();
        return {};
    }

    const auto &foundDevice = m_foundDevices.at(index.row());

    switch (role)
    {
    case Qt::DisplayRole: return tr("Device %0").arg(foundDevice.serial);
    case SerialRole: return foundDevice.serial;
    case ManufacturerRole: return foundDevice.manufacturer;
    case DeviceTypeRole: return foundDevice.deviceType;
    case FriendlyNameRole: return foundDevice.friendlyName;
    case PasswordRole: return foundDevice.password;
    case SavedRole: return foundDevice.saved;
    case HostNameRole: return foundDevice.hostName;
    case IpRole: return foundDevice.ip.toString();
    }

    return {};
}

QMap<int, QVariant> DevicesModel::itemData(const QModelIndex &index) const
{
    if (index.row() < 0 || index.row() >= m_foundDevices.size())
    {
        qWarning() << "invalid row" << index.row();
        return {};
    }

    const auto &foundDevice = m_foundDevices.at(index.row());

    return {
        { Qt::DisplayRole, tr("Device %0").arg(foundDevice.serial) },
        { SerialRole,foundDevice.serial },
        { ManufacturerRole, foundDevice.manufacturer },
        { DeviceTypeRole, foundDevice.deviceType },
        { FriendlyNameRole, foundDevice.friendlyName },
        { PasswordRole, foundDevice.password },
        { SavedRole, foundDevice.saved },
        { HostNameRole, foundDevice.hostName },
        { IpRole, foundDevice.ip.toString() }
    };
}

QHash<int, QByteArray> DevicesModel::roleNames() const
{
    return {
        { Qt::DisplayRole, "name" },
        { SerialRole, "serial" },
        { ManufacturerRole, "manufacturer" },
        { DeviceTypeRole, "deviceType" },
        { FriendlyNameRole, "friendlyName" },
        { PasswordRole, "password" },
        { SavedRole, "saved" },
        { HostNameRole, "hostName" },
        { IpRole, "ip" }
    };
}

bool DevicesModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || row >= m_foundDevices.size())
    {
        qWarning() << "invalid row" << row;
        return false;
    }

    if (count != 1)
    {
        qWarning() << "only count=1 is supported!" << count;
        return false;
    }

    auto iter = std::next(std::begin(m_foundDevices), row);

    if (!iter->saved)
    {
        qWarning() << "row is not saved" << row << iter->serial;
        return false;
    }

    if (m_settings)
        m_settings->removeSavedDevice(iter->serial);

    if (iter->ip.isNull())
    {
        beginRemoveRows({}, row, row);
        m_foundDevices.erase(iter);
        endRemoveRows();
    }
    else
    {
        FoundDevice device = std::move(*iter);
        device.saved = false;
        device.password.clear();

        beginRemoveRows({}, row, row);
        m_foundDevices.erase(iter);
        endRemoveRows();

        beginInsertRows({}, m_foundDevices.size(), m_foundDevices.size());
        m_foundDevices.emplace_back(std::move(device));
        endInsertRows();
    }

    return true;
}

void DevicesModel::error(QZeroConf::error_t error)
{
    qDebug() << error;
}

void DevicesModel::serviceAdded(QZeroConfService service)
{

    auto txt = service->txt();

    auto serialIter = txt.find("serial");
    if (serialIter == txt.end())
    {
        qWarning() << service->host() << "serial missing" << txt;
        return;
    }
    auto serial = *serialIter;

    auto manufacturerIter = txt.find("manufacturer");
    if (manufacturerIter == txt.end())
    {
        qWarning() << service->host() << "manufacturer missing" << txt;
        return;
    }
    auto manufacturer = *manufacturerIter;

    auto deviceTypeIter = txt.find("devicetype");
    if (deviceTypeIter == txt.end())
    {
        qWarning() << service->host() << "devicetype missing" << txt;
        return;
    }
    auto deviceType = *deviceTypeIter;

    auto friendlyNameIter = txt.find("friendly_name");
    if (friendlyNameIter == txt.end())
    {
        qWarning() << service->host() << "friendly_name missing" << txt;
        return;
    }
    auto friendlyName = *friendlyNameIter;

    const auto iter = std::find_if(std::begin(m_foundDevices), std::end(m_foundDevices), [&serial](const FoundDevice &foundDevice){
        return foundDevice.serial == serial;
    });

    if (iter == std::end(m_foundDevices))
    {
        qDebug() << "new device" << service->host() << serial << manufacturer << deviceType << friendlyName;

        beginInsertRows({}, m_foundDevices.size(), m_foundDevices.size());
        m_foundDevices.emplace_back(FoundDevice {
            /*.serial{ */ std::move(serial) /*}*/,
            /*.manufacturer{ */ std::move(manufacturer) /*}*/,
            /*.deviceType{ */ std::move(deviceType) /*}*/,
            /*.friendlyName{ */ std::move(friendlyName) /*}*/,
            /*.password{ */ {} /*}*/,
            /*.saved{ */ false /*}*/,
            /*.hostName{ */ service->host() /*}*/,
            /*.ip{ */ service->ip() /*}*/
        });
        endInsertRows();
    }
    else
    {
        qDebug() << "device already in list" << service->host() << serial << manufacturer << deviceType << friendlyName;

        iter->manufacturer = std::move(manufacturer);
        iter->deviceType = std::move(deviceType);
        iter->friendlyName = std::move(friendlyName);
        iter->hostName = service->host();
        iter->ip = service->ip();

        const auto index = createIndex(std::distance(std::begin(m_foundDevices), iter), 0);
        emit dataChanged(index, index, {
            ManufacturerRole,
            DeviceTypeRole,
            FriendlyNameRole,
            HostNameRole,
            IpRole
        });
    }
}

void DevicesModel::serviceUpdated(QZeroConfService service)
{
    qDebug() << service->host();

    // TODO
}

void DevicesModel::serviceRemoved(QZeroConfService service)
{
    const auto &txt = service->txt();

    auto serialIter = txt.find("serial");
    if (serialIter == txt.constEnd())
    {
        qWarning() << service->host() << "serial missing" << txt;
        return;
    }
    auto serial = *serialIter;

    const auto iter = std::find_if(std::begin(m_foundDevices), std::end(m_foundDevices), [&serial](const FoundDevice &foundDevice){
        return foundDevice.serial == serial;
    });

    if (iter == std::end(m_foundDevices))
    {
        qWarning() << service->host() << "serial not found!" << serial;
        return;
    }

    if (!iter->saved)
    {
        qDebug() << "device removed" << service->host() << serial;

        const auto row = std::distance(std::begin(m_foundDevices), iter);
        beginRemoveRows({}, row, row);
        m_foundDevices.erase(iter);
        endRemoveRows();
    }
    else
    {
        qDebug() << "device kept" << service->host() << serial;

        iter->hostName.clear();
        iter->ip = {};
        const auto index = createIndex(std::distance(std::begin(m_foundDevices), iter), 0);
        emit dataChanged(index, index, {
            HostNameRole,
            IpRole
        });
    }
}
