#pragma once

#include <QDialog>
#include <QAbstractSocket>

#include <memory>

namespace Ui { class ImportCredentialsDialog; }
class DeviceConnection;

class ImportCredentialsDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ImportCredentialsDialog(QWidget *parent = nullptr);
    ~ImportCredentialsDialog();

    QByteArray username() const;
    QByteArray password() const;

public slots:
    void accept() override;

private slots:
    void connected();
    void disconnected();
    void errorOccurred(QAbstractSocket::SocketError error);

private:
    void finishTestConnection();

    const std::unique_ptr<Ui::ImportCredentialsDialog> m_ui;
    std::unique_ptr<DeviceConnection> m_testConnection;
};
