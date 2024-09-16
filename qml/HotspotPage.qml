import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Hotspot")

    GeneralOnOffSwitch {
        apiKey: "wae"
    }

    GeneralOnOffSwitch {
        apiKey: "wda"
        text: qsTr("Disable AP when online")
    }

    EditValueItem {
        text: qsTr("SSID")
        apiKey: "wan"
        fullWidth: true
        editableItem: TextField {
            id: textField0
            property alias value: textField0.text
        }
    }

    EditValueItem {
        text: qsTr("Password")
        apiKey: "wak"
        fullWidth: true
        editableItem: TextField {
            id: textField1
            property alias value: textField1.text
        }
    }

    EditValueItem {
        text: qsTr("Channel")
        valueText: Qt.locale().toString(value)
        apiKey: "wapc"
        editableItem: SpinBox {
            from: 0
            to: 15
        }
    }
}
