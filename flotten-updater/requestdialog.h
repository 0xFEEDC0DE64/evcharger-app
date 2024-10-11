#pragma once

#include <QDialog>

#include <memory>

class QJsonObject;
class ChargerConnection;
class RequestModel;

namespace Ui { class RequestDialog; }

class RequestDialog : public QDialog
{
    Q_OBJECT

public:
    explicit RequestDialog(QJsonObject &&msg, std::vector<std::shared_ptr<ChargerConnection>> &&chargers, QWidget *parent = nullptr);
    ~RequestDialog();

private:
    const std::unique_ptr<Ui::RequestDialog> m_ui;
    const std::unique_ptr<RequestModel> m_model;
};
