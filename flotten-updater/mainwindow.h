#pragma once

#include <QMainWindow>
#include <QAbstractItemModel>

#include <memory>

namespace Ui { class MainWindow; }
class QSslKey;
class QSslCertificate;
class QItemSelection;
class DevicesModel;
class QSortFilterProxyModel;
class FlottenUpdaterSettings;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(FlottenUpdaterSettings &settings, const QSslKey &key,
                        const QSslCertificate &cert, QWidget *parent = nullptr);
    ~MainWindow() override;

private slots:
    void doAdd();
    void doRemove();
    void doAddRange();
    void selectionChanged();
    void headerContextMenuRequested(const QPoint &pos);
    void contextMenuRequested(const QPoint &pos);

private:
    void removeRows(QModelIndexList &&indexes);

    const std::unique_ptr<Ui::MainWindow> m_ui;
    FlottenUpdaterSettings &m_settings;
    const std::unique_ptr<DevicesModel> m_model;
    const std::unique_ptr<QSortFilterProxyModel> m_proxyModel;
};
