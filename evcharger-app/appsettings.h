#pragma once

#include <QtQml/qqmlregistration.h>

#include "goesettings.h"

class AppSettings : public GoeSettings
{
    Q_OBJECT
    QML_ELEMENT

public:
    Q_INVOKABLE bool loadSolalawebKey(const QString &url);
    Q_INVOKABLE bool loadSolalawebCert(const QString &url);
};
