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
#include <utility>

#include "flottenupdatersettings.h"
#include "devicesmodel.h"
#include "requestdialog.h"
#include "setarbitraryapikeydialog.h"

MainWindow::MainWindow(FlottenUpdaterSettings &settings, const QSslKey &key,
                       const QSslCertificate &cert, QWidget *parent) :
    QMainWindow{parent},
    m_ui{std::make_unique<Ui::MainWindow>()},
    m_settings{settings},
    m_model{std::make_unique<DevicesModel>(settings, key, cert, this)},
    m_proxyModel{std::make_unique<QSortFilterProxyModel>(this)}
{
    m_ui->setupUi(this);

    m_proxyModel->setSourceModel(m_model.get());
    m_proxyModel->setSortRole(Qt::EditRole);
    m_ui->treeView->setModel(m_proxyModel.get());

    connect(m_ui->pushButtonConnectAll, &QAbstractButton::pressed, m_model.get(), &DevicesModel::connectAll);
    connect(m_ui->pushButtonDisconnectAll, &QAbstractButton::pressed, m_model.get(), &DevicesModel::disconnectAll);
    connect(m_ui->pushButtonAdd, &QAbstractButton::pressed, this, &MainWindow::doAdd);
    connect(m_ui->pushButtonRemove, &QAbstractButton::pressed, this, &MainWindow::doRemove);
    connect(m_ui->treeView->selectionModel(), &QItemSelectionModel::selectionChanged, this, &MainWindow::selectionChanged);
    m_ui->treeView->header()->setContextMenuPolicy(Qt::CustomContextMenu);
    connect(m_ui->treeView->header(), &QTreeView::customContextMenuRequested, this, &MainWindow::headerContextMenuRequested);
    connect(m_ui->treeView, &QTreeView::customContextMenuRequested, this, &MainWindow::contextMenuRequested);
    selectionChanged();
}

MainWindow::~MainWindow() = default;

void MainWindow::doAdd()
{
    bool ok{};
    const auto serial = QInputDialog::getText(this, tr("Serial"), tr("Serial"), QLineEdit::Normal, {}, &ok);
    if (!ok)
        return;
    m_model->addClient(serial);
    m_settings.setSerials(m_model->serials());
}

void MainWindow::doRemove()
{
    auto selectedRows = m_ui->treeView->selectionModel()->selectedRows();
    if (selectedRows.isEmpty())
        return;

    // map proxied indices to those from the model
    std::transform(std::begin(selectedRows), std::end(selectedRows), std::begin(selectedRows),
                   [&](const QModelIndex &index){ return m_proxyModel->mapToSource(index); });

    removeRows(std::move(selectedRows));
}

void MainWindow::selectionChanged()
{
    auto count = m_ui->treeView->selectionModel()->selectedRows().count();
    m_ui->pushButtonRemove->setEnabled(count > 0);
    m_ui->statusbar->showMessage(tr("%0 selected").arg(m_ui->treeView->selectionModel()->selectedRows().count()));
}

void MainWindow::headerContextMenuRequested(const QPoint &pos)
{
    QMenu menu;

    auto addColumnAction = menu.addAction(tr("Add new column..."));

    QAction *removeColumnAction{};
    auto header = m_ui->treeView->header();
    const auto section = header->logicalIndexAt(pos);
    if (section >= 0)
    {
        removeColumnAction = menu.addAction(tr("Remove column %0").arg(header->model()->headerData(section, Qt::Horizontal).toString()));
        if (!m_model->customColumnRemovable(section))
            removeColumnAction->setEnabled(false);
    }

    if (auto selectedAction = menu.exec(header->mapToGlobal(pos)); selectedAction == addColumnAction)
    {
        bool ok{};
        auto apiKey = QInputDialog::getText(this, tr("Enter api key"), tr("Api key:"), QLineEdit::Normal, {}, &ok);
        if (!ok)
            return;

        m_model->addCustomColumn(apiKey);
    }
    else if (removeColumnAction && selectedAction == removeColumnAction)
    {
        m_model->removeCustomColumn(section);
    }
}

void MainWindow::contextMenuRequested(const QPoint &pos)
{
    auto selectedRows = m_ui->treeView->selectionModel()->selectedRows();
    if (selectedRows.isEmpty())
        return;

    // map proxied indices to those from the model
    std::transform(std::begin(selectedRows), std::end(selectedRows), std::begin(selectedRows),
                   [&](const QModelIndex &index){ return m_proxyModel->mapToSource(index); });

    // get all the devices for selected indices
    std::vector<std::shared_ptr<DevicesConnection>> devices;
    devices.reserve(selectedRows.size());
    std::transform(std::begin(selectedRows), std::end(selectedRows), std::back_inserter(devices),
                   [&](const QModelIndex &index){ auto device = m_model->getDevice(index); Q_ASSERT(device); return device; });

    Q_ASSERT(std::all_of(std::begin(devices), std::end(devices), [](const auto &device)->bool{ return device.get(); }));

    QMenu menu;
    auto actionSetUpdateUrl = menu.addAction(tr("Set update url..."));
    auto actionStartUpdate = menu.addAction(tr("Start update..."));
    auto actionReboot = menu.addAction(tr("Reboot..."));
    auto actionSetChargectrlOverride = menu.addAction(tr("Set chargectrl override..."));
    auto actionSetAbitraryApiKey = menu.addAction(tr("Set abitrary api key..."));
    auto resetNvsKey = menu.addAction(tr("Reset nvs key..."));
    auto actionOpenApps = menu.addAction(tr("Open app(s)..."));
    auto actionRemove = menu.addAction(tr("Remove..."));
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
        RequestDialog{std::move(msg), std::move(devices), this}.exec();
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
        RequestDialog{std::move(msg), std::move(devices), this}.exec();
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
            RequestDialog{std::move(msg), std::move(devices), this}.exec();
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
        RequestDialog{std::move(msg), std::move(devices), this}.exec();
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
            RequestDialog{std::move(msg), std::move(devices), this}.exec();
        }
    }
    else if (selected == resetNvsKey)
    {
        bool ok{};
        auto nvsKey = QInputDialog::getText(this, tr("Please input nvs key to be reset"), tr("Nvs key"), QLineEdit::Normal, {}, &ok);
        if (!ok)
            return;

        QJsonObject msg {
            { "type", "nvsReset" },
            { "key", nvsKey },
            { "sudo", true }
        };
        RequestDialog{std::move(msg), std::move(devices), this}.exec();
    }
    else if (selected == actionOpenApps)
    {

    }
    else if (selected == actionRemove)
    {
        removeRows(std::move(selectedRows));
    }
}

void MainWindow::removeRows(QModelIndexList &&indexes)
{
    if (QMessageBox::question(
            this,
            tr("Confirm deletion of devices"),
            tr("Do you really want to remove %0 devices?").arg(indexes.count())
        ) != QMessageBox::Yes)
        return;

    int succeeded{}, failed{};

    std::sort(indexes.begin(), indexes.end(),
              [](const QModelIndex &a, const QModelIndex &b) {
                  return a.row() > b.row();
              });

    for (const QModelIndex &index : std::as_const(indexes))
        if (m_model->removeRows(index.row(), 1, index.parent()))
            succeeded++;
        else
        {
            failed++;
            qWarning() << "removing row" << index.row() << "failed";
        }

    if (succeeded > 0)
        m_settings.setSerials(m_model->serials());

    if (failed > 0)
        QMessageBox::warning(this, tr("Error while removing!"), tr("%0 rows could not be removed!").arg(failed));
}
