#include "importcertificatedialog.h"
#include "ui_importcertificatedialog.h"

#include <QFileDialog>
#include <QFile>
#include <QMessageBox>
#include <QInputDialog>
#include <QSslSocket>

#ifdef HAS_OPENSSL
#include <openssl/provider.h>
#endif

#ifdef HAS_OPENSSL
namespace {
OSSL_PROVIDER *legacy{};
}
#endif

ImportCertificateDialog::ImportCertificateDialog(QWidget *parent) :
    QDialog{parent},
    m_ui{std::make_unique<Ui::ImportCertificateDialog>()}
{
    m_ui->setupUi(this);

    connect(m_ui->pushButtonImport, &QPushButton::clicked, this, &ImportCertificateDialog::loadP12File);
    connect(m_ui->plainTextEditKey, &QPlainTextEdit::textChanged, this, &ImportCertificateDialog::keyChanged);
    connect(m_ui->plainTextEditCert, &QPlainTextEdit::textChanged, this, &ImportCertificateDialog::certChanged);

    m_ui->labelSupportsSslValue->setText(QSslSocket::supportsSsl() ? tr("Yes") : tr("No"));
    m_ui->labelSslLibraryVersionValue->setText(QSslSocket::sslLibraryVersionString());
    m_ui->labelSslLibraryBuildVersionValue->setText(QSslSocket::sslLibraryBuildVersionString());
    const auto &availableBackends = QSslSocket::availableBackends();
    for (const auto &backend : availableBackends)
        m_ui->comboBoxSslBackend->addItem(backend);
    m_ui->comboBoxSslBackend->setCurrentText(QSslSocket::activeBackend());
    connect(m_ui->comboBoxSslBackend, &QComboBox::currentIndexChanged,
            this, &ImportCertificateDialog::updateActiveBackend);
}

ImportCertificateDialog::~ImportCertificateDialog() = default;

void ImportCertificateDialog::accept()
{
    if (m_key.isNull())
        return;
    if (m_cert.isNull())
        return;

    QDialog::accept();
}

void ImportCertificateDialog::loadP12File()
{
    auto selected = QFileDialog::getOpenFileName(this, tr("Select certificate..."), {}, "Certificates (*.p12)");
    if (selected.isEmpty())
        return;

    QFile file{selected};
    if (!file.open(QIODevice::ReadOnly))
    {
        QMessageBox::warning(this, tr("Could not open file!"), tr("Could not open file!") + "\n\n" + file.errorString());
        return;
    }

    bool ok{};
    QString passwordStr = QInputDialog::getText(this, tr("Please enter password"), tr("Certificate password:"), QLineEdit::PasswordEchoOnEdit, {}, &ok);
    if (!ok)
        return;

    auto password = passwordStr.toUtf8();

    QSslKey key;
    QSslCertificate cert;
    QList<QSslCertificate> certChain;

#ifdef HAS_OPENSSL
    if (QSslSocket::activeBackend() == "openssl" && !legacy)
    {
        legacy = OSSL_PROVIDER_load(NULL, "legacy");
        if (!legacy)
            QMessageBox::warning(this, tr("Failed to load openssl legacy provider!"), tr("Failed to load openssl legacy provider!"));
    }
#endif

    if (!QSslCertificate::importPkcs12(&file, &key, &cert, &certChain, password))
    {
        QMessageBox::warning(this, tr("Failed processing certificate!"), tr("Failed processing certificate!") + "\n\n" + tr("Possible reasons: openssl has a problem, the file is corrupt/invalid or the password is incorrect."));
        return;
    }

    if (key.isNull())
    {
        QMessageBox::warning(this, tr("Failed processing certificate!"), tr("Failed processing certificate!") + "\n\n" + tr("The key seems to be invalid."));
        return;
    }

    if (cert.isNull())
    {
        QMessageBox::warning(this, tr("Failed processing certificate!"), tr("Failed processing certificate!") + "\n\n" + tr("The cert seems to be invalid."));
        return;
    }

    m_key = std::move(key);
    m_cert = std::move(cert);

    {
        QSignalBlocker blocker{m_ui->plainTextEditKey};
        m_ui->plainTextEditKey->setPlainText(m_key.toPem());
    }

    {
        auto palette = m_ui->plainTextEditKey->palette();
        palette.setBrush(QPalette::Base, QColor{200, 255, 200});
        palette.setBrush(QPalette::Window, QColor{200, 255, 200});
        m_ui->plainTextEditKey->setPalette(palette);
    }

    {
        QSignalBlocker blocker{m_ui->plainTextEditCert};
        m_ui->plainTextEditCert->setPlainText(m_cert.toPem());
    }

    {
        auto palette = m_ui->plainTextEditCert->palette();
        palette.setBrush(QPalette::Base, QColor{200, 255, 200});
        palette.setBrush(QPalette::Window, QColor{200, 255, 200});
        m_ui->plainTextEditCert->setPalette(palette);
    }
}

void ImportCertificateDialog::keyChanged()
{
    m_key = QSslKey{m_ui->plainTextEditKey->toPlainText().toUtf8(), QSsl::KeyAlgorithm::Rsa, QSsl::Pem};

    auto palette = m_ui->plainTextEditKey->palette();
    palette.setBrush(QPalette::Base, m_key.isNull() ? QColor{255, 200, 200} : QColor{200, 255, 200});
    palette.setBrush(QPalette::Window, m_key.isNull() ? QColor{255, 200, 200} : QColor{200, 255, 200});
    m_ui->plainTextEditKey->setPalette(palette);
}

void ImportCertificateDialog::certChanged()
{
    m_cert = QSslCertificate{m_ui->plainTextEditCert->toPlainText().toUtf8()};

    auto palette = m_ui->plainTextEditCert->palette();
    palette.setBrush(QPalette::Base, m_cert.isNull() ? QColor{255, 200, 200} : QColor{200, 255, 200});
    palette.setBrush(QPalette::Window, m_cert.isNull() ? QColor{255, 200, 200} : QColor{200, 255, 200});
    m_ui->plainTextEditCert->setPalette(palette);
}

void ImportCertificateDialog::updateActiveBackend()
{
    if (!QSslSocket::setActiveBackend(m_ui->comboBoxSslBackend->currentText()))
        QMessageBox::warning(this, tr("Could not change active backend"), tr("Could not change active backend"));
    m_ui->comboBoxSslBackend->setCurrentText(QSslSocket::activeBackend());
}
