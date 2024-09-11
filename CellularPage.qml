import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Cellular")

    ConfirmingOnOffSwitch {
        apiKey: "cen"
        dialogTitle: qsTr("Are you sure?")
        dialogText: qsTr("Disabling Cellular could make your device unreachable from the cloud!")
    }

    EditValueItem {
        text: qsTr("APN")
        apiKey: "moap"
        fullWidth: true
        editableItem: TextField {
            id: textField0
            property alias value: textField0.text
        }
    }

    EditValueItem {
        text: qsTr("PIN")
        apiKey: "mopi"
        fullWidth: true
        editableItem: TextField {
            id: textField1
            property alias value: textField1.text
        }
    }

    // TODO auth Type

    EditValueItem {
        text: qsTr("Username")
        apiKey: "mau"
        fullWidth: true
        editableItem: TextField {
            id: textField2
            property alias value: textField2.text
        }
    }

    EditValueItem {
        text: qsTr("Password")
        apiKey: "mpap"
        fullWidth: true
        editableItem: TextField {
            id: textField3
            property alias value: textField3.text
        }
    }

    WhiteItemDelegate {
        id: delegate
        Layout.fillWidth: true

        text: qsTr("Show technical details of LTE modem")

        onClicked: {
            gridLayout.visible = true
            delegate.text = null
            delegate.implicitWidth = Qt.binding(() => gridLayout.implicitWidth + gridLayout.anchors.leftMargin + gridLayout.anchors.rightMargin)
            delegate.implicitHeight = Qt.binding(() => gridLayout.implicitHeight + gridLayout.anchors.topMargin + gridLayout.anchors.bottomMargin)
        }

        GridLayout {
            id: gridLayout

            columns: 2
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.topMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            visible: false

            ApiKeyValueHelper {
                id: misApiKey
                deviceConnection: theDeviceConnection
                apiKey: "mis"
            }

            Label {
                text: qsTr("Initialization status:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(misApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: imeiApiKey
                deviceConnection: theDeviceConnection
                apiKey: "imei"
            }

            Label {
                text: qsTr("IMEI:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(imeiApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: imsiApiKey
                deviceConnection: theDeviceConnection
                apiKey: "imsi"
            }

            Label {
                text: qsTr("IMSI:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(imsiApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: mpsApiKey
                deviceConnection: theDeviceConnection
                apiKey: "mps"
            }

            Label {
                text: qsTr("Pin status:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(mpsApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: monApiKey
                deviceConnection: theDeviceConnection
                apiKey: "mon"
            }

            Label {
                text: qsTr("Operator name:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(monApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: msqApiKey
                deviceConnection: theDeviceConnection
                apiKey: "msq"
            }

            Label {
                text: qsTr("Signal quality:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(msqApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: ccmApiKey
                deviceConnection: theDeviceConnection
                apiKey: "ccm"
            }

            Label {
                text: qsTr("Current system mode:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(ccmApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            ApiKeyValueHelper {
                id: miaApiKey
                deviceConnection: theDeviceConnection
                apiKey: "mia"
            }

            Label {
                text: qsTr("IP Address:")
                font.bold: true
            }

            Text {
                text: JSON.stringify(miaApiKey.value, null, 2)
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }
}
