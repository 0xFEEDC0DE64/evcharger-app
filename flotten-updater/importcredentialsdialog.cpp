#include "importcredentialsdialog.h"
#include "ui_importcredentialsdialog.h"

#include <QMessageBox>
#include <QPushButton>

#include "deviceconnection.h"

ImportCredentialsDialog::ImportCredentialsDialog(QWidget *parent) :
    QDialog{parent},
    m_ui{std::make_unique<Ui::ImportCredentialsDialog>()}
{
    m_ui->setupUi(this);
}

ImportCredentialsDialog::~ImportCredentialsDialog() = default;

QByteArray ImportCredentialsDialog::username() const
{
    return m_ui->lineEditUsername->text().toUtf8();
}

QByteArray ImportCredentialsDialog::password() const
{
    return m_ui->lineEditPassword->text().toUtf8();
}

void ImportCredentialsDialog::accept()
{
    if (username().isEmpty() ||
        password().isEmpty())
    {
        QMessageBox::warning(this, tr("Please fill out all fields!"), tr("Please fill out all fields!"));
        return;
    }

    m_ui->lineEditUsername->setEnabled(false);
    m_ui->lineEditPassword->setEnabled(false);
    if (auto button = m_ui->buttonBox->button(QDialogButtonBox::Save))
        button->setEnabled(false);

    m_testConnection = std::make_unique<DeviceConnection>(username(), password(), "123456");
    connect(m_testConnection.get(), &DeviceConnection::connectedSignal,
            this, &ImportCredentialsDialog::connected);
    connect(m_testConnection.get(), &DeviceConnection::disconnectedSignal,
            this, &ImportCredentialsDialog::disconnected);
    connect(m_testConnection.get(), &DeviceConnection::errorOccurredSignal,
            this, &ImportCredentialsDialog::errorOccurred);
    m_testConnection->start();
}

void ImportCredentialsDialog::connected()
{
    qDebug() << "called";

    QDialog::accept();

    finishTestConnection();
}

void ImportCredentialsDialog::disconnected()
{
    qDebug() << "called";

    finishTestConnection();
}

void ImportCredentialsDialog::errorOccurred(QAbstractSocket::SocketError error)
{
    Q_ASSERT(m_testConnection);
    QMessageBox::warning(this,
                         tr("Problem verifying credentials!"),
                         QString("%0\n\n%1")
                             .arg(QMetaEnum::fromType<QAbstractSocket::SocketError>().valueToKey(error))
                             .arg(m_testConnection->errorString())
                         );
}

void ImportCredentialsDialog::finishTestConnection()
{
    Q_ASSERT(m_testConnection);

    m_ui->lineEditUsername->setEnabled(true);
    m_ui->lineEditPassword->setEnabled(true);
    if (auto button = m_ui->buttonBox->button(QDialogButtonBox::Save))
        button->setEnabled(true);

    m_testConnection.release()->deleteLater();
}
