import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Cellular")

    ConfirmingOnOffSwitch {
        apiKey: "cen"
        dialogTitle: qsTr("Are you sure?")
        dialogText: qsTr("Disabling Cellular could make your device unreachable from the cloud!")
    }

    EditValueItem {
        text: qsTr("APN")
        apiKey: "moap"
        fullWidth: true
        editableItem: TextField {
            id: textField0
            property alias value: textField0.text
        }
    }

    EditValueItem {
        text: qsTr("PIN")
        apiKey: "mopi"
        fullWidth: true
        editableItem: TextField {
            id: textField1
            property alias value: textField1.text
        }
    }

    // TODO auth Type

    EditValueItem {
        text: qsTr("Username")
        apiKey: "mau"
        fullWidth: true
        editableItem: TextField {
            id: textField2
            property alias value: textField2.text
        }
    }

    EditValueItem {
        text: qsTr("Password")
        apiKey: "mpap"
        fullWidth: true
        editableItem: TextField {
            id: textField3
            property alias value: textField3.text
        }
    }
}
