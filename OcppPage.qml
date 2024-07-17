import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("OCPP")

    GeneralOnOffSwitch {
        apiKey: "ocppe"
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
                apiKey: "ocpps"
            }

            Text {
                text: qsTr("Is connected:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "ocppc"
            }

            Text {
                text: qsTr("Connected since:")
                font.bold: true
            }

            ApiKeyValueHelper {
                id: connectedSince
                deviceConnection: theDeviceConnection
                apiKey: "ocppca"
            }

            Text {
                text: connectedSince.value ? formatDuration(connectedSince.value - rebootTime.value) : ""
            }

            Text {
                text: qsTr("Is accepted:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "ocppa"
            }

            Text {
                text: qsTr("Accepted since:")
                font.bold: true
            }

            ApiKeyValueHelper {
                id: acceptedSince
                deviceConnection: theDeviceConnection
                apiKey: "ocppaa"
            }

            Text {
                text: acceptedSince.value ? formatDuration(acceptedSince.value - rebootTime.value) : ""
            }

            Text {
                text: qsTr("Last error:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "ocpple"
                wrapMode: Text.Wrap
            }

            Text {
                text: qsTr("Last error age:")
                font.bold: true
            }

            ApiKeyValueHelper {
                id: lastErrorAge
                deviceConnection: theDeviceConnection
                apiKey: "ocpplea"
            }

            Text {
                text: lastErrorAge.value ? formatDuration(lastErrorAge.value - rebootTime.value) : ""
            }

            Text {
                text: qsTr("Chargepoint status:")
                font.bold: true
            }

            ApiKeyValueHelper {
                id: chargepointStatus
                deviceConnection: theDeviceConnection
                apiKey: "ocppcs"
            }

            Text {
                text: {
                    switch (chargepointStatus.value)
                    {
                    case 0: return qsTr("Available")
                    case 1: return qsTr("Preparing")
                    case 2: return qsTr("Charging")
                    case 3: return qsTr("SuspendedEVSE")
                    case 4: return qsTr("SuspendedEV")
                    case 5: return qsTr("Finishing")
                    case 6: return qsTr("Reserved")
                    case 7: return qsTr("Unavailable")
                    case 8: return qsTr("Faulted")
                    }
                    return chargepointStatus.value
                }
            }
        }
    }
}
