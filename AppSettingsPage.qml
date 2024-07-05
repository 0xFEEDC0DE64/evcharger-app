import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("App Settings")

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: gridLayout.implicitHeight
        color: "white"
        radius: 5

        GridLayout {
            id: gridLayout
            columns: 2

            Label {
                text: qsTr("Number of app instances:")
                font.bold: true
            }

            SpinBox {
                value: theSettings.numberOfAppInstances
                onValueModified: theSettings.numberOfAppInstances = value
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: gridLayout2.implicitHeight
        color: "white"
        radius: 5

        GridLayout {
            id: gridLayout2
            columns: 2

            Label {
                text: qsTr("solalaweb key:")
                font.bold: true
            }

            Button {
                text: qsTr("Select...")
            }

            Label {
                text: qsTr("solalaweb cert:")
                font.bold: true
            }

            Button {
                text: qsTr("Select...")
            }
        }
    }
}
