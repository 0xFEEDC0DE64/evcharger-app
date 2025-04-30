#pragma once

#include <QDialog>

#include <memory>

namespace Ui { class AddSerialsRangeDialog; }

class AddSerialsRangeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit AddSerialsRangeDialog(QWidget *parent = nullptr);
    ~AddSerialsRangeDialog();

    void accept() override;

    int from() const;
    int to() const;

private:
    void updatePreview();

private:
    const std::unique_ptr<Ui::AddSerialsRangeDialog> m_ui;
};
