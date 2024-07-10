import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("MQTT")

    GeneralOnOffSwitch {
        apiKey: "mce"
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
                apiKey: "mcs"
            }

            Text {
                text: qsTr("Is connected:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "mcc"
            }

            Text {
                text: qsTr("Connected since:")
                font.bold: true
            }

            ApiKeyValueHelper {
                id: connectedSince
                deviceConnection: mainScreen.deviceConnection
                apiKey: "mcca"
            }

            Text {
                text: connectedSince.value ? formatDuration(connectedSince.value - rebootTime.value) : ""
            }

            Text {
                text: qsTr("Command Counter:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "mcsl"
            }

            Text {
                text: qsTr("Last error:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "mlr"
                wrapMode: Text.Wrap
            }

            Text {
                text: qsTr("Last error age:")
                font.bold: true
            }

            ApiKeyValueHelper {
                id: lastErrorAge
                deviceConnection: mainScreen.deviceConnection
                apiKey: "mlra"
            }

            Text {
                text: lastErrorAge.value ? formatDuration(lastErrorAge.value - rebootTime.value) : ""
            }
        }
    }
}
