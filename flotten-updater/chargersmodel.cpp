#include "chargersmodel.h"

#include <QDebug>
#include <QBrush>
#include <QJsonDocument>

#include <algorithm>

#include "chargerconnection.h"
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

ChargersModel::ChargersModel(FlottenUpdaterSettings &settings, const QSslKey &key,
                             const QSslCertificate &cert, QObject *parent) :
    QAbstractTableModel{parent},
    m_settings{settings},
    m_key{key},
    m_cert{cert},
    m_customColumns{settings.customColumns()}
{
    constexpr const char *serials[] {
        "096850", "10000003",
        "000010", "000011", "000012", "000013", "000014", "000015", "000016", "000017", "000018", "000019", "000020", "000021", "000022", "000023", "000024", "000025", "000026", "000027", "000028", "000029",
        "000030", "000031", "000032", "000033", "000034", "000035", "000036", "000037", "000038", "000039",
        "999900", "999901", "999902", "999903", "999904", "999905", "999906", "999907", "999908", "999909",
        "999910", "999911", "999912", "999913", "999914", "00999915", "00999916", "00999917", "00999918", "00999919",
        "999920", "00999921", "00999922", "999923", "00999924", "00999925", "999926", "999927", "999928", "999929",
        "91000286",
        "31416778", "31416779", "31416780", "31416781", "31416783", "31416784", "31416786", "31416787", "31416788", "31416789", "31416790", "31416791", "31416793", "31416794", "31416795", "31416796", "31416797", "31416798", "31416799", "31416800", "31416801", "31416802", "31416803", "31416804", "31416806", "31416807", "31416808", "31416809", "31416810", "31416811", "31416814", "31416815", "31416816", "31416817", "31416818", "31416819",
        "91000001", "91000002", "91000003", "91000004", "91000005", "91000006", "91000007", "91000008", "91000009", "91000010", "91000011", "91000012", "91000013", "91000014", "91000015", "91000016", "91000017", "91000018", "91000019", "91000020", "91000021", "91000022", "91000023", "91000024", "91000025", "91000026", "91000027", "91000028", "91000029", "91000030", "91000031", "91000032", "91000033", "91000034", "91000035", "91000036", "91000037", "91000038", "91000039", "91000040",
        "000043", "000044", "000047", "000050", "900001", "900103", "900104", "900105", "900107", "900108", "900113", "900117", "900118", "900123", "900126", "900127",
        "91028339", "91028457", "91028482", "91028368", "91028336", "91028374", "91028371", "91028452", "91028481", "91028455", "91028334", "91028456", "91028351", "91028367", "91028346", "91028459", "91028366", "91028335", "91028483", "91028372", "91028337", "91028338",
        "91008954", "91008978", "91008282", "91009008", "91008953", "91009000", "91009024", "91048840", "91048873", "91045590", "91045593", "91045586", "91048874", "91048879", "91048882", "91048878", "91048860", "91048865", "91048853", "91048864", "91048867", "91021261", "91021260", "91021379", "91021135", "91021266", "91021259", "91021374", "91021381", "91021258", "91021275", "91021380", "91021382", "91021377", "91021240", "91021371", "91021376", "91021255", "91021378", "91021383", "91021354", "91021195", "91021370", "91021278", "91021234", "91021256", "91021257", "91021360", "91021248", "91021363", "91021270", "91021267", "91021239", "91021193", "91021268", "91028339", "91028457", "91028482", "91028368", "91036167", "91028374", "91028371", "91028452", "91028481", "91028455", "91028334", "91028456", "91028351", "91028367", "91028346", "91028459", "91028366", "91028335", "91028483", "91028372", "91028337", "91028338",
        "91100000", "91100001", "91100002", "91100003", "91100004", "91100005", "91100006", "91100007", "91100008", "91100009", "91100010", "91100011", "91100012", "91100013", "91100014", "91100015", "91100016", "91100017", "91100018", "91100019", "91100020", "91100021", "91100022", "91100023", "91100024", "91100025", "91100026", "91100027", "91100028", "91100029", "91100030", "91100031"
    };
    for (const auto &serial : serials)
    {
        if (std::none_of(std::cbegin(m_chargers), std::cend(m_chargers), [&serial](auto &ptr){
            return ptr->serial() == serial;
        }))
        m_chargers.emplace_back(std::make_shared<ChargerConnection>(m_key, m_cert, serial, this));
    }
}

ChargersModel::~ChargersModel() = default;

int ChargersModel::rowCount(const QModelIndex &parent) const
{
    return m_chargers.size();
}

int ChargersModel::columnCount(const QModelIndex &parent) const
{
    return NumberOfColumns + m_customColumns.size();
}

QVariant ChargersModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_chargers.size())
    {
        qWarning() << "row out of bounds";
        return {};
    }

    const ChargerConnection &charger = **std::next(std::begin(m_chargers), index.row());

    switch (index.column())
    {
    case ColumnSerial:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.serial();
        }
        return {};
    case ColumnWsStatus:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.wsStatusText();
        case Qt::BackgroundRole:
            return charger.wsStatusBackground();
        }
        return {};
    case ColumnStatus:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.statusText();
        case Qt::BackgroundRole:
            return charger.statusBackground();
        }
        return {};
    case ColumnVariant:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.variantText();
        case Qt::BackgroundRole:
            return charger.variantBackground();
        }
        return {};
    case ColumnIsGo:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.isGoText();
        case Qt::BackgroundRole:
            return charger.isGoBackground();
        }
        return {};
    case ColumnIsAustralien:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.isAustralienText();
        case Qt::BackgroundRole:
            return charger.isAustralienBackground();
        }
        return {};
    case ColumnResetCard:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.resetCardText();
        case Qt::BackgroundRole:
            return charger.resetCardBackground();
        }
        return {};
    case ColumnConnectedWifi:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.connectedWifiText();
        }
        return {};
    case ColumnProject:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.projectText();
        }
        return {};
    case ColumnVersion:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.versionText();
        }
        return {};
    case ColumnIdfVersion:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.idfVersionText();
        }
        return {};
    case ColumnUpdate:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.updateText();
        case Qt::BackgroundRole:
            return charger.updateBackground();
        }
        return {};
    case ColumnUptime:
        switch (role)
        {
        case Qt::DisplayRole:
            return charger.uptimeText();
        case Qt::EditRole:
            if (const auto uptime = charger.uptime(); uptime)
                return *uptime;
        }
        return {};
    case ColumnCurrentPartition:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.currentPartition();
        }
        return {};
    case ColumnReboots:
        switch (role)
        {
        case Qt::DisplayRole:
            return charger.rebootsText();
        case Qt::EditRole:
            if (const auto reboots = charger.reboots(); reboots)
                return *reboots;
        }
        return {};
    case ColumnCarState:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.carStateText();
        }
        return {};
    case ColumnEnergy:
        switch (role)
        {
        case Qt::DisplayRole:
            return charger.energyText();
        case Qt::EditRole:
            if (const auto energy = charger.energy(); energy)
                return *energy;
        }
        return {};
    case ColumnLivedata:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return charger.livedataText();
        }
        return {};
    }

    if (index.column() >= NumberOfColumns && index.column() - NumberOfColumns < m_customColumns.size())
        switch (role)
        {
        case Qt::DisplayRole:
        {
            auto variant = charger.getApiKey(m_customColumns.at(index.column() - NumberOfColumns));
            auto str = variant.toString();
            if (str.isEmpty())
                str = QJsonDocument::fromVariant(variant).toJson(QJsonDocument::Compact);
            return str;
        }
        case Qt::EditRole:
            return charger.getApiKey(m_customColumns.at(index.column() - NumberOfColumns));
        }

    return {};
}

QVariant ChargersModel::headerData(int section, Qt::Orientation orientation, int role) const
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

void ChargersModel::addClient(const QString &serial)
{
    beginInsertRows({}, m_chargers.size(), m_chargers.size());

    auto clientPtr = std::make_shared<ChargerConnection>(m_key, m_cert, serial, this);
    auto client = clientPtr.get();
    m_chargers.emplace_back(std::move(clientPtr));

    endInsertRows();

    client->start();
}

std::shared_ptr<ChargerConnection> ChargersModel::getCharger(QModelIndex index)
{
    Q_ASSERT(!index.parent().isValid());
    Q_ASSERT(index.row() >= 0 && index.row() < m_chargers.size());
    auto charger = m_chargers.at(index.row());
    Q_ASSERT(charger);
    return charger;
}

std::shared_ptr<const ChargerConnection> ChargersModel::getCharger(QModelIndex index) const
{
    Q_ASSERT(!index.parent().isValid());
    return m_chargers.at(index.row());
}

void ChargersModel::addCustomColumn(const QString &apiKey)
{
    beginInsertColumns({}, NumberOfColumns + m_customColumns.size(), NumberOfColumns + m_customColumns.size());
    m_customColumns.push_back(apiKey);
    endInsertColumns();
    m_settings.setCustomColumns(m_customColumns);
}

bool ChargersModel::customColumnRemovable(int section)
{
    return section >= NumberOfColumns && section - NumberOfColumns < m_customColumns.size();
}

void ChargersModel::removeCustomColumn(int section)
{
    if (section < NumberOfColumns || section - NumberOfColumns >= m_customColumns.size())
        return;

    beginRemoveColumns({}, section, section);
    m_customColumns.erase(std::next(std::begin(m_customColumns), section - NumberOfColumns));
    endRemoveColumns();
    m_settings.setCustomColumns(m_customColumns);
}

void ChargersModel::connectAll()
{
    for (auto &charger : m_chargers)
        charger->start();
}

void ChargersModel::disconnectAll()
{
    for (auto &charger : m_chargers)
        charger->stop();
}

void ChargersModel::wsStatusChanged()
{
    columnChanged(ColumnWsStatus, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::statusChanged()
{
    columnChanged(ColumnStatus, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::variantChanged()
{
    columnChanged(ColumnVariant, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::isGoChanged()
{
    columnChanged(ColumnIsGo, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::isAustralienChanged()
{
    columnChanged(ColumnIsAustralien, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::resetCardChanged()
{
    columnChanged(ColumnResetCard, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::connectedWifiChanged()
{
    columnChanged(ColumnConnectedWifi, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::projectChanged()
{
    columnChanged(ColumnProject, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::versionChanged()
{
    columnChanged(ColumnVersion, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::idfVersionChanged()
{
    columnChanged(ColumnIdfVersion, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::updateChanged()
{
    columnChanged(ColumnUpdate, {Qt::DisplayRole, Qt::EditRole, Qt::BackgroundRole});
}

void ChargersModel::uptimeChanged()
{
    columnChanged(ColumnUptime, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::currentPartitionChanged()
{
    columnChanged(ColumnCurrentPartition, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::rebootsChanged()
{
    columnChanged(ColumnReboots, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::carStateChanged()
{
    columnChanged(ColumnCarState, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::energyChanged()
{
    columnChanged(ColumnEnergy, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::livedataChanged()
{
    columnChanged(ColumnLivedata, {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::apiKeyChanged(const QString &apiKey)
{
    for (auto iter = std::cbegin(m_customColumns); iter != std::cend(m_customColumns); iter++)
        if (*iter == apiKey)
            columnChanged(NumberOfColumns + std::distance(std::cbegin(m_customColumns), iter), {Qt::DisplayRole, Qt::EditRole});
}

void ChargersModel::columnChanged(int column, const QList<int> &roles)
{
    auto charger = qobject_cast<ChargerConnection*>(sender());
    if (!charger)
    {
        qWarning() << "unknown sender" << sender();
        return;
    }

    auto iter = std::find_if(std::cbegin(m_chargers), std::cend(m_chargers), [&charger](const std::shared_ptr<ChargerConnection> &ptr){ return charger == ptr.get(); });
    if (iter == std::cend(m_chargers))
    {
        qWarning() << "unknown sender" << charger;
        for (const auto &charger : m_chargers)
            qDebug() << charger.get();
        return;
    }

    auto row = std::distance(std::cbegin(m_chargers), iter);

    auto index = createIndex(row, column);
    emit dataChanged(index, index, roles);
}
