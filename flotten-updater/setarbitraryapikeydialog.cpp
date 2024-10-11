#include "setarbitraryapikeydialog.h"
#include "ui_setarbitraryapikeydialog.h"

#include <QJsonDocument>
#include <QJsonParseError>
#include <QMessageBox>
#include <QJsonArray>
#include <QJsonObject>

SetArbitraryApiKeyDialog::SetArbitraryApiKeyDialog(QWidget *parent) :
    QDialog{parent},
    m_ui{std::make_unique<Ui::SetArbitraryApiKeyDialog>()}
{
    m_ui->setupUi(this);
}

SetArbitraryApiKeyDialog::~SetArbitraryApiKeyDialog() = default;

QString SetArbitraryApiKeyDialog::apiKey() const
{
    return m_ui->lineEditApiKey->text();
}

QJsonValue SetArbitraryApiKeyDialog::value() const
{
    return m_value;
}

bool SetArbitraryApiKeyDialog::sudo() const
{
    return m_ui->checkBoxSudo->isChecked();
}

void SetArbitraryApiKeyDialog::accept()
{
    QJsonParseError error;
    const auto doc = QJsonDocument::fromJson("[" + m_ui->plainTextEditValue->toPlainText().toUtf8() + "]", &error);
    if (error.error != QJsonParseError::NoError)
    {
        QMessageBox::warning(this, tr("Could not parse JSON"), tr("Could not parse JSON") + "\n\n" + error.errorString());
        return;
    }

    if (!doc.isArray())
    {
        QMessageBox::warning(this, tr("Unexpected not array!"), tr("Unexpected not array!"));
        return;
    }

    const auto array = doc.array();

    if (array.size() != 1)
    {
        QMessageBox::warning(this, tr("Unexpected array length!"), tr("Unexpected array length: %0!").arg(array.size()));
        return;
    }

    m_value = array.first();

    QDialog::accept();
}
