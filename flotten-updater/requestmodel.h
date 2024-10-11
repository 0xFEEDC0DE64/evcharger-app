#pragma once

#include <QObject>
#include <QAbstractTableModel>

#include <memory>

class QJsonObject;
class ChargerConnection;

class RequestModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit RequestModel(QJsonObject &&msg, std::vector<std::shared_ptr<ChargerConnection>> &&chargers, QObject *parent = nullptr);
    ~RequestModel() override;

    // QAbstractItemModel interface
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

private slots:
    void responseReceived(const QString &requestId, const QJsonObject &msg);

private:
    struct Request {
        std::shared_ptr<ChargerConnection> charger;
        QString requestId;
        enum class Status { Pending, Failed, Succeeded };
        Status status{Status::Pending};
        QString message;
    };
    std::vector<Request> m_requests;
};
