import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteCheckDelegate {
    id: checkDelegate

    Layout.fillWidth: true

    Component.onCompleted: {
        contentItem.children[0].wrapMode = Text.Wrap
    }

    ApiKeyValueHelper {
        id: staEnabled
        deviceConnection: theDeviceConnection
        apiKey: "wen"
    }

    SendMessageHelper {
        id: staEnabledChanger
        deviceConnection: theDeviceConnection
    }

    checked: staEnabled.value
    text: staEnabled.value ? qsTr("On") : qsTr("Off")

    onClicked: {
        if (checked)
            staEnabledChanger.sendMessage({
                type: "setValue",
                key: "wen",
                value: checked
            })
        else {
            checked = true
            disableStaDialog.open()
        }
    }

    BusyIndicator {
        visible: staEnabledChanger.pending
    }

    RequestStatusText {
        request: staEnabledChanger
    }

    CenteredDialog {
        id: disableStaDialog

        title: qsTr("Are you sure?")
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        onAccepted: {
            checkDelegate.checked = false
            staEnabledChanger.sendMessage({
                type: "setValue",
                key: "wen",
                value: false
            })
        }
        onRejected: checkDelegate.checked = Qt.binding(function() { return staEnabled.value })

        contentItem: Text {
            text: qsTr("Disabling Wi-Fi could make your device unreachable from your local homenetwork or the cloud!");
            wrapMode: Text.Wrap
        }
    }
}
