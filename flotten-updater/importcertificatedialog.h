#pragma once

#include <QDialog>
#include <QSslKey>
#include <QSslCertificate>

#include <memory>

namespace Ui { class ImportCertificateDialog; }

class ImportCertificateDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ImportCertificateDialog(QWidget *parent = nullptr);
    ~ImportCertificateDialog();

    const QSslKey &privateKey() const { return m_key; }
    const QSslCertificate &privateCert() const { return m_cert; }

public slots:
    void accept() override;

private slots:
    void loadP12File();
    void keyChanged();
    void certChanged();
    void updateActiveBackend();

private:
    const std::unique_ptr<Ui::ImportCertificateDialog> m_ui;

    QSslKey m_key;
    QSslCertificate m_cert;
};
