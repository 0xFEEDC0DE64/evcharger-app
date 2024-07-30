import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Charging Speed")

    Text {
        text: "current limits TODO"

        Layout.fillWidth: true
    }

    SelectPhaseSwitchModeItem {
        Layout.fillWidth: true
    }
}
