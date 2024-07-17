import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteCheckDelegate {
    id: checkDelegate

    required property string apiKey
    property alias exists: valueHelper.exists

    Layout.fillWidth: true

    Component.onCompleted: {
        contentItem.children[0].wrapMode = Text.Wrap
    }

    ApiKeyValueHelper {
        id: valueHelper
        deviceConnection: theDeviceConnection
        apiKey: checkDelegate.apiKey
    }

    SetValueHelper {
        id: valueChanger
        deviceConnection: theDeviceConnection
        apiKey: checkDelegate.apiKey
        onResponseChanged: checkDelegate.checked = Qt.binding(function(){ return valueHelper.value; })
    }

    checked: valueHelper.value
    text: valueHelper.value ? qsTr("On") : qsTr("Off")

    onClicked: {
        valueChanger.setValue(checked)
    }

    BusyIndicator {
        visible: valueChanger.pending
    }

    RequestStatusText {
        request: valueChanger
    }
}
