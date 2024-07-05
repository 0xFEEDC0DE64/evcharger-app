import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Hardware information")

    Rectangle {
        color: "white"
        radius: 5
        Layout.fillWidth: true
        Layout.preferredHeight: layout.implicitHeight

        GridLayout {
            id: layout
            columns: 2
            anchors.fill: parent

            Label {
                text: qsTr("Serial Number:")
            }

            ApiKeyValueItem {
                Layout.fillWidth: true
                apiKey: "sse"
            }

            Label {
                visible: variant.exists
                text: qsTr("Variant:")
            }

            ApiKeyValueItem {
                id: variant
                visible: exists
                Layout.fillWidth: true
                apiKey: "var"
            }

            Label {
                visible: rssi.exists
                text: qsTr("RSSI:")
            }

            ApiKeyValueItem {
                id: rssi
                visible: exists
                Layout.fillWidth: true
                apiKey: "rssi"
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
