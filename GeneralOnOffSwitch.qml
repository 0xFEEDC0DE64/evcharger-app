import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

CheckDelegate {
    id: checkDelegate

    required property string apiKey
    property alias exists: valueHelper.exists

    Layout.fillWidth: true

    Component.onCompleted: {
        background.color = "white"
        background.radius = 5
        contentItem.children[0].wrapMode = Text.Wrap
    }

    ApiKeyValueHelper {
        id: valueHelper
        deviceConnection: mainScreen.deviceConnection
        apiKey: checkDelegate.apiKey
    }

    SendMessageHelper {
        id: valueChanger
        deviceConnection: mainScreen.deviceConnection
        onResponseChanged: checkDelegate.checked = Qt.binding(function(){ return valueHelper.value; })
    }

    checked: valueHelper.value
    text: valueHelper.value ? qsTr("On") : qsTr("Off")

    onClicked: {
        valueChanger.sendMessage({
            type: "setValue",
            key: checkDelegate.apiKey,
            value: checked
        })
    }

    BusyIndicator {
        visible: valueChanger.pending
    }

    RequestStatusText {
        request: valueChanger
    }
}
