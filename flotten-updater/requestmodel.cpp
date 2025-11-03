#include "requestmodel.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QRandomGenerator>

#include <algorithm>
#include <utility>

#include "deviceconnection.h"

namespace {
enum {
    ColumnSerial,
    ColumnRequestId,
    ColumnStatus,
    ColumnMessage,
    NumberOfColumns
};

QString getRandomString();
}

RequestModel::RequestModel(QJsonObject &&msg, std::vector<std::shared_ptr<DeviceConnection>> &&devices, QObject *parent) :
    QAbstractTableModel{parent}
{
    m_requests.reserve(devices.size());

    for (auto &device : devices)
    {
        Request request {
            .device = std::move(device),
            .requestId = getRandomString()
        };

        connect(request.device.get(), &DeviceConnection::responseReceived, this, &RequestModel::responseReceived);

        {
            QJsonObject msg2 = msg;
            msg2["requestId"] = request.requestId;
            request.device->sendMessage(msg2);
        }

        m_requests.emplace_back(std::move(request));
    }
}

RequestModel::~RequestModel() = default;

int RequestModel::rowCount(const QModelIndex &parent) const
{
    return m_requests.size();
}

int RequestModel::columnCount(const QModelIndex &parent) const
{
    return NumberOfColumns;
}

QVariant RequestModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_requests.size())
    {
        qWarning() << "row out of bounds";
        return {};
    }

    const Request &request = *std::next(std::begin(m_requests), index.row());

    switch (index.column())
    {
    case ColumnSerial:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return request.device->serial();
        }
        return {};
    case ColumnRequestId:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return request.requestId;
        }
        return {};
    case ColumnStatus:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (request.status)
            {
            case Request::Status::Pending: return tr("Pending");
            case Request::Status::Failed: return tr("Failed");
            case Request::Status::Succeeded: return tr("Succeeded");
            }
            return QString::number(std::to_underlying(request.status));
        case Qt::EditRole:
            return std::to_underlying(request.status);
        }
        return {};
    case ColumnMessage:
        switch (role)
        {
        case Qt::DisplayRole:
        case Qt::EditRole:
            return request.message;
        }
        return {};
    }
    return {};
}

QVariant RequestModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole && role != Qt::EditRole)
        return {};

    switch (orientation)
    {
    case Qt::Horizontal:
        switch (section)
        {
        case ColumnSerial: return tr("Serial");
        case ColumnRequestId: return tr("RequestId");
        case ColumnStatus: return tr("Status");
        case ColumnMessage: return tr("Message");
        }
        return {};
    }

    return {};
}

void RequestModel::responseReceived(const QString &requestId, const QJsonObject &msg)
{
    qDebug() << requestId << msg;

    auto iter = std::find_if(std::begin(m_requests), std::end(m_requests),
                             [&requestId](const auto &request){ return request.requestId == requestId; });
    if (iter == std::end(m_requests))
    {
        qWarning() << "unknown request id" << requestId;
        return;
    }

    const auto row = std::distance(std::begin(m_requests), iter);
    if (msg.value("success").toBool())
    {
        iter->status = Request::Status::Succeeded;
        emit dataChanged(index(row, ColumnStatus), index(row, ColumnStatus), { Qt::DisplayRole, Qt::EditRole });
    }
    else
    {
        iter->status = Request::Status::Failed;
        iter->message = msg.value("message").toString();
        emit dataChanged(index(row, ColumnStatus), index(row, ColumnMessage), { Qt::DisplayRole, Qt::EditRole });
    }
}

namespace {
QString getRandomString()
{
   const QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
   const int randomStringLength = 12; // assuming you want random strings of 12 characters

   QString randomString;
   for(int i = 0; i<randomStringLength; ++i)
   {
       int index = QRandomGenerator::global()->bounded(possibleCharacters.length());
       QChar nextChar = possibleCharacters.at(index);
       randomString.append(nextChar);
   }
   return randomString;
}
}
