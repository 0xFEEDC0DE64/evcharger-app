import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteCheckDelegate {
    id: checkDelegate

    required property string apiKey
    required property string dialogTitle
    required property string dialogText

    Layout.fillWidth: true

    Component.onCompleted: {
        contentItem.children[0].wrapMode = Text.Wrap
    }

    ApiKeyValueHelper {
        id: apiKeyValueHelper
        deviceConnection: theDeviceConnection
        apiKey: checkDelegate.apiKey
    }

    SetValueHelper {
        id: setValueHelper
        deviceConnection: theDeviceConnection
        apiKey: checkDelegate.apiKey
    }

    checked: apiKeyValueHelper.value
    text: apiKeyValueHelper.value === true ? qsTr("On") : apiKeyValueHelper.value === false ? qsTr("Off") : qsTr("Unknown")

    onClicked: {
        if (checked)
            setValueHelper.setValue(checked)
        else {
            checked = true
            disableStaDialog.open()
        }
    }

    BusyIndicator {
        visible: setValueHelper.pending
    }

    RequestStatusText {
        request: setValueHelper
    }

    CenteredDialog {
        id: disableStaDialog

        title: checkDelegate.dialogTitle
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        onAccepted: {
            checkDelegate.checked = false
            setValueHelper.setValue(false)
        }
        onRejected: checkDelegate.checked = Qt.binding(function() { return apiKeyValueHelper.value })

        contentItem: Text {
            text: checkDelegate.dialogText
            wrapMode: Text.Wrap
        }
    }
}
