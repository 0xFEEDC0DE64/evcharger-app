import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Cloud")

    GeneralOnOffSwitch {
        Layout.fillWidth: true
        apiKey: "cwe"
        text: qsTr("Enable cloud connection")
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

            Label {
                text: qsTr("Trying to connect:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "cws"
            }

            Label {
                text: qsTr("Is connected:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "cwsc"
            }

            // TODO cwsca

            Label {
                text: qsTr("Hello received:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "chr"
            }

            Label {
                text: qsTr("Queue size cloud:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "qsc"
            }

            Label {
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
