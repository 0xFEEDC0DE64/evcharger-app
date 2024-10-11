#pragma once

#include <memory>
#include <QDialog>
#include <QJsonValue>

namespace Ui { class SetArbitraryApiKeyDialog; }

class SetArbitraryApiKeyDialog : public QDialog
{
    Q_OBJECT

public:
    explicit SetArbitraryApiKeyDialog(QWidget *parent = nullptr);
    ~SetArbitraryApiKeyDialog() override;

    QString apiKey() const;
    QJsonValue value() const;
    bool sudo() const;

protected:
    void accept() override;

private:
    const std::unique_ptr<Ui::SetArbitraryApiKeyDialog> m_ui;

    QJsonValue m_value;
};
