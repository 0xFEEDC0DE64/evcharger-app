#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QInputDialog>
#include <QSortFilterProxyModel>
#include <QMenu>
#include <QInputDialog>
#include <QMessageBox>
#include <QJsonObject>
#include <QJsonArray>

#include <algorithm>

#include "flottenupdatersettings.h"
#include "chargersmodel.h"
#include "requestdialog.h"
#include "setarbitraryapikeydialog.h"

MainWindow::MainWindow(FlottenUpdaterSettings &settings, const QSslKey &key,
                       const QSslCertificate &cert, QWidget *parent) :
    QMainWindow{parent},
    m_ui{std::make_unique<Ui::MainWindow>()},
    m_settings{settings},
    m_model{std::make_unique<ChargersModel>(key, cert, this)},
    m_proxyModel{std::make_unique<QSortFilterProxyModel>(this)}
{
    m_ui->setupUi(this);

    m_proxyModel->setSourceModel(m_model.get());
    m_proxyModel->setSortRole(Qt::EditRole);
    m_ui->treeView->setModel(m_proxyModel.get());

    connect(m_ui->pushButtonConnectAll, &QAbstractButton::pressed, m_model.get(), &ChargersModel::connectAll);
    connect(m_ui->pushButtonDisconnectAll, &QAbstractButton::pressed, m_model.get(), &ChargersModel::disconnectAll);
    connect(m_ui->pushButtonAdd, &QAbstractButton::pressed, this, &MainWindow::doAdd);
    connect(m_ui->pushButtonRemove, &QAbstractButton::pressed, this, &MainWindow::doRemove);
    connect(m_ui->treeView->selectionModel(), &QItemSelectionModel::selectionChanged, this, &MainWindow::selectionChanged);
    connect(m_ui->treeView, &QTreeView::customContextMenuRequested, this, &MainWindow::contextMenuRequested);
}

MainWindow::~MainWindow() = default;

void MainWindow::doAdd()
{
    bool ok{};
    const auto serial = QInputDialog::getText(this, tr("Serial"), tr("Serial"), QLineEdit::Normal, {}, &ok);
    if (!ok)
        return;

    m_model->addClient(serial);
}

void MainWindow::doRemove()
{
    QMessageBox::warning(this, tr("Not yet implemented!"), tr("Not yet implemented!"));
}

void MainWindow::selectionChanged()
{
    m_ui->statusbar->showMessage(tr("%0 selected").arg(m_ui->treeView->selectionModel()->selectedRows().count()));
}

void MainWindow::contextMenuRequested(const QPoint &pos)
{
    auto selectedRows = m_ui->treeView->selectionModel()->selectedRows();
    if (selectedRows.isEmpty())
        return;

    // map proxied indices to those from the model
    std::transform(std::begin(selectedRows), std::end(selectedRows), std::begin(selectedRows),
                   [&](const QModelIndex &index){ return m_proxyModel->mapToSource(index); });

    // get all the chargers for selected indices
    std::vector<std::shared_ptr<ChargerConnection>> chargers;
    chargers.reserve(selectedRows.size());
    std::transform(std::begin(selectedRows), std::end(selectedRows), std::back_inserter(chargers),
                   [&](const QModelIndex &index){ auto charger = m_model->getCharger(index); Q_ASSERT(charger); return charger; });

    Q_ASSERT(std::all_of(std::begin(chargers), std::end(chargers), [](const auto &charger)->bool{ return charger.get(); }));

    QMenu menu;
    auto actionSetUpdateUrl = menu.addAction(tr("Set update url..."));
    auto actionStartUpdate = menu.addAction(tr("Start update..."));
    auto actionReboot = menu.addAction(tr("Reboot..."));
    auto actionSetChargectrlOverride = menu.addAction(tr("Set chargectrl override..."));
    auto actionSetAbitraryApiKey = menu.addAction(tr("Set abitrary api key..."));
    if (const auto selected = menu.exec(m_ui->treeView->viewport()->mapToGlobal(pos)); selected == actionSetUpdateUrl)
    {
        bool ok{};
        const auto url = QInputDialog::getText(this, tr("Enter update url..."), tr("Update url:"), QLineEdit::Normal, {}, &ok);
        if (!ok)
            return;
        QJsonObject msg {
            { "type", "setValue" },
            { "key", "ocu" },
            { "value", url },
            { "sudo", true }
        };
        RequestDialog{std::move(msg), std::move(chargers), this}.exec();
    }
    else if (selected == actionStartUpdate)
    {
        QString branch;
        {
            QInputDialog dialog{this};
            dialog.setWindowTitle(tr("Select update release..."));
            dialog.setInputMode(QInputDialog::TextInput);
            dialog.setLabelText(tr("Update release"));
            dialog.setComboBoxEditable(true);
            dialog.setComboBoxItems({QStringLiteral("__default")});
            if (dialog.exec() != QDialog::Accepted)
                return;
            branch = dialog.textValue();
        }
        QJsonObject msg {
            { "type", "setValue" },
            { "key", "oct" },
            { "value", branch },
            { "sudo", true }
        };
        RequestDialog{std::move(msg), std::move(chargers), this}.exec();
    }
    else if (selected == actionReboot)
    {
        if (const auto result = QMessageBox::question(this, tr("Are you sure?"), tr("Do you really want to reboot selected devices?")); result == QMessageBox::Yes)
        {
            QJsonObject msg {
                { "type", "setValue" },
                { "key", "rst" },
                { "value", 1 },
                { "sudo", true }
            };
            RequestDialog{std::move(msg), std::move(chargers), this}.exec();
        }
    }
    else if (selected == actionSetChargectrlOverride)
    {
        QJsonObject msg {
            { "type", "setValue" },
            { "key", "stao" },
            { "value", QJsonObject {
                { "car", 2 },
                { "error", 0 },
                { "phases",  QJsonArray {
                    true,
                    true,
                    true,
                    true,
                    true,
                    true
                } },
                { "temperature", 30 },
                { "voltageL1", 230 },
                { "voltageL2", 230 },
                { "voltageL3", 230 },
                { "voltageN", 0 },
                { "ampereL1", 32 },
                { "ampereL2", 32 },
                { "ampereL3", 32 },
                { "powerL1", 7360 },
                { "powerL2", 7360 },
                { "powerL3", 7360 },
                { "powerN", 0 },
                { "powerTotal", 22080 },
                { "powerFactorL1", 90 },
                { "powerFactorL2", 90 },
                { "powerFactorL3", 90 },
                { "powerFactorN",  0 }
            } },
            { "sudo", true }
        };
        RequestDialog{std::move(msg), std::move(chargers), this}.exec();
    }
    else if (selected == actionSetAbitraryApiKey)
    {
        SetArbitraryApiKeyDialog dialog{this};
        if (dialog.exec() == QDialog::Accepted)
        {
            QJsonObject msg {
                { "type", "setValue" },
                { "key", dialog.apiKey() },
                { "value", dialog.value() }
            };
            if (dialog.sudo())
                msg["sudo"] = true;
            RequestDialog{std::move(msg), std::move(chargers), this}.exec();
        }
    }
}
