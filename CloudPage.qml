import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Cloud")

    ConfirmingOnOffSwitch {
        apiKey: "cwe"
        text: qsTr("Enable cloud connection")
        dialogTitle: qsTr("Are you sure?")
        dialogText: qsTr("Disabling could connection could make your device unreachable from other places than home!")
    }

    Text {
        Layout.fillWidth: true
        wrapMode: Text.Wrap
        text: qsTr("Features like flexible energy tariffs, time sync and app connection are unavilable when \"Enable cloud connection\" is disabled")
    }

    WhiteBox {
        Layout.fillWidth: true

        GridLayout {
            anchors.fill: parent
            columns: 2

            Text {
                text: qsTr("Trying to connect:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "cws"
            }

            Text {
                text: qsTr("Is connected:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "cwsc"
            }

            // TODO cwsca

            Text {
                text: qsTr("Hello received:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "chr"
            }

            Text {
                text: qsTr("Queue size cloud:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "qsc"
            }

            Text {
                text: qsTr("Last error:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "cle"
                wrapMode: Text.Wrap
            }
        }
    }
}
