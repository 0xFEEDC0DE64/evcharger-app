import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Hardware information")

    WhiteBox {
        Layout.fillWidth: true

        GridLayout {
            columns: 2
            anchors.fill: parent

            Text {
                text: qsTr("Serial Number:")
            }

            ApiKeyValueItem {
                Layout.fillWidth: true
                apiKey: "sse"
            }

            Text {
                visible: variant.exists
                text: qsTr("Variant:")
            }

            ApiKeyValueItem {
                id: variant
                visible: exists
                Layout.fillWidth: true
                apiKey: "var"
            }

            Text {
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
