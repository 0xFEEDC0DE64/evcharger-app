#include "requestdialog.h"
#include "ui_requestdialog.h"

#include <QJsonDocument>
#include <QJsonObject>

#include "chargerconnection.h"
#include "requestmodel.h"

RequestDialog::RequestDialog(QJsonObject &&msg, std::vector<std::shared_ptr<ChargerConnection>> &&chargers, QWidget *parent) :
    QDialog{parent},
    m_ui{std::make_unique<Ui::RequestDialog>()},
    m_model{std::make_unique<RequestModel>(std::move(msg), std::move(chargers), this)}
{
    m_ui->setupUi(this);
    m_ui->treeView->setModel(m_model.get());
}

RequestDialog::~RequestDialog() = default;
