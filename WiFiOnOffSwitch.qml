import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

CheckDelegate {
    id: checkDelegate

    Layout.fillWidth: true

    Component.onCompleted: {
        background.color = "white"
        background.radius = 5
    }

    ApiKeyValueHelper {
        id: staEnabled
        deviceConnection: mainScreen.deviceConnection
        apiKey: "wen"
    }

    SendMessageHelper {
        id: staEnabledChanger
        deviceConnection: mainScreen.deviceConnection
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

    Dialog {
        id: disableStaDialog

        x: window.width / 2 - width / 2
        y: window.height / 2 - height / 2
        width: Math.min(implicitWidth, window.width - 20)

        title: qsTr("Do you really want to disable Wi-Fi?")
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
            text: qsTr("This action could make your device unreachable from your local homenetwork or the cloud!");
            wrapMode: Text.Wrap
        }
    }
}
