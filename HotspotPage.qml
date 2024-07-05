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

    Text {
        text: "TODO"

        Layout.fillHeight: true
    }
}
