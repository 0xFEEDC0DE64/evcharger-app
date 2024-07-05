import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

Text {
    property alias apiKey: apiKeyValueHelper.apiKey
    property alias exists: apiKeyValueHelper.exists

    Layout.fillWidth: true

    ApiKeyValueHelper {
        id: apiKeyValueHelper
        deviceConnection: mainScreen.deviceConnection
    }

    text: apiKeyValueHelper.value
}
