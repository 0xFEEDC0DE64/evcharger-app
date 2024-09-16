import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("MQTT")

    GeneralOnOffSwitch {
        apiKey: "mce"
    }

    EditValueItem {
        text: qsTr("Broker url")
        apiKey: "mcu"
        fullWidth: true
        editableItem: TextField {
            id: textField0
            property alias value: textField0.text
        }
    }

    Button {
        text: qsTr("API documentation")
        onClicked: Qt.openUrlExternally(qsTr("https://github.com/goecharger/go-eCharger-API-v2/blob/main/mqtt-en.md"))
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
                deviceConnection: theDeviceConnection
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
                deviceConnection: theDeviceConnection
                apiKey: "mlra"
            }

            Text {
                text: lastErrorAge.value ? formatDuration(lastErrorAge.value - rebootTime.value) : ""
            }
        }
    }

    GeneralOnOffSwitch {
        apiKey: "mqg"
        text: qsTr("Use global CA store")
    }

    GeneralOnOffSwitch {
        apiKey: "mqcn"
        text: qsTr("Skip cert commonName check")
    }

    GeneralOnOffSwitch {
        apiKey: "mqss"
        text: qsTr("Skip server cert verification")
    }

    // TODO clientKey

    // TODO clientCert

    // TODO serverCert

    GeneralOnOffSwitch {
        apiKey: "mcr"
        text: qsTr("MQTT readonly")
    }

    EditValueItem {
        // TODO allow set to null to reset to default
        text: qsTr("Topic prefix")
        apiKey: "mtp"
        fullWidth: true
        editableItem: TextField {
            id: textField1
            property alias value: textField1.text
        }
    }

    GeneralOnOffSwitch {
        id: homeassistant
        apiKey: "mhe"
        text: qsTr("Homeassistant autodiscover")
    }

    EditValueItem {
        visible: homeassistant.checked
        // TODO allow set to null to reset to default
        text: qsTr("Homeassistant topic prefix")
        apiKey: "mht"
        fullWidth: true
        editableItem: TextField {
            id: textField2
            property alias value: textField2.text
        }
    }
}
