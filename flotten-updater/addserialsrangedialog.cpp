#include "addserialsrangedialog.h"
#include "ui_addserialsrangedialog.h"

AddSerialsRangeDialog::AddSerialsRangeDialog(QWidget *parent) :
    QDialog{parent},
    m_ui{std::make_unique<Ui::AddSerialsRangeDialog>()}
{
    m_ui->setupUi(this);

    connect(m_ui->spinBoxFrom, &QSpinBox::valueChanged,
            this, &AddSerialsRangeDialog::updatePreview);
    connect(m_ui->spinBoxTo, &QSpinBox::valueChanged,
            this, &AddSerialsRangeDialog::updatePreview);
    updatePreview();
}

AddSerialsRangeDialog::~AddSerialsRangeDialog() = default;

void AddSerialsRangeDialog::accept()
{
    if (from() > to())
        return;
    QDialog::accept();
}

int AddSerialsRangeDialog::from() const
{
    return m_ui->spinBoxFrom->value();
}

int AddSerialsRangeDialog::to() const
{
    return m_ui->spinBoxTo->value();
}

void AddSerialsRangeDialog::updatePreview()
{
    const auto from = this->from();
    const auto to = this->to();

    QString text;
    QColor color;
    if (from > to)
    {
        text = tr("???");
        color = Qt::red;
    }
    else
    {
        const auto count = to - from + 1;
        text = tr("%0 serials").arg(count);
        color = count > 100 ? Qt::yellow : Qt::green;
    }

    m_ui->labelCountDisplay->setText(text);

    QPalette palette = m_ui->labelCountDisplay->palette();
    palette.setColor(m_ui->labelCountDisplay->backgroundRole(), color);
    palette.setColor(m_ui->labelCountDisplay->foregroundRole(), color);
    m_ui->labelCountDisplay->setPalette(palette);
}
