import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteItemDelegate {
    id: itemDelegate

    required property string apiKey
    property string valueText: apiKeyValueHelper.value
    property alias editableItem: dialog.contentItem
    property alias value: apiKeyValueHelper.value
    property bool fullWidth: false

    Layout.fillWidth: true

    ApiKeyValueHelper {
        id: apiKeyValueHelper
        deviceConnection: theDeviceConnection
        apiKey: itemDelegate.apiKey
    }

    SetValueHelper {
        id: setValueHelper
        deviceConnection: theDeviceConnection
        apiKey: itemDelegate.apiKey
    }

    contentItem: RowLayout {
        Text {
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            font.bold: true
            text: itemDelegate.text
        }

        Text {
            text: itemDelegate.valueText
        }

        Text {
            text: ">"
        }
    }

    onClicked: {
        editableItem.value = value
        dialog.open()
    }

    CenteredDialog {
        id: dialog

        title: itemDelegate.text
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        Binding {
            target: dialog
            property: "width"
            value: dialog.parent.width
            when: fullWidth
        }

        onAccepted: {
            console.log(editableItem.value)
            setValueHelper.setValue(editableItem.value)
        }
    }
}
