#pragma once

#include <QMainWindow>

#include <memory>

namespace Ui { class MainWindow; }
class QSslKey;
class QSslCertificate;
class QItemSelection;
class ChargersModel;
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
    void selectionChanged();
    void contextMenuRequested(const QPoint &pos);

private:
    const std::unique_ptr<Ui::MainWindow> m_ui;
    FlottenUpdaterSettings &m_settings;
    const std::unique_ptr<ChargersModel> m_model;
    const std::unique_ptr<QSortFilterProxyModel> m_proxyModel;
};
