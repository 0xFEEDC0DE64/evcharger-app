import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("OCPP")

    GeneralOnOffSwitch {
        apiKey: "ocppe"
    }

    EditValueItem {
        text: qsTr("Backend url")
        apiKey: "ocppu"
        fullWidth: true
        editableItem: TextField {
            id: textField0
            property alias value: textField0.text
        }
    }

    OpenLinkButton {
        text: qsTr("API documentation")
        url: qsTr("https://github.com/goecharger/go-eCharger-API-v2/blob/main/ocpp-en.md")
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

    GeneralOnOffSwitch {
        apiKey: "ocppg"
        text: qsTr("Use global CA store")
    }

    GeneralOnOffSwitch {
        apiKey: "ocppcn"
        text: qsTr("Skip cert commonName check")
    }

    GeneralOnOffSwitch {
        apiKey: "ocppss"
        text: qsTr("Skip server cert verification")
    }

    // TODO clientKey

    // TODO clientCert

    // TODO serverCert

    // TODO fallbackCurrentLimit

    // TODO transactionId

    EditValueItem {
        text: qsTr("Heartbeat interval:")
        valueText: Qt.locale().toString(value)
        apiKey: "ocpph"
        editableItem: SpinBox {
            from: 0
            to: 3600
        }
    }

    EditValueItem {
        text: qsTr("MeterValues sample interval:")
        valueText: Qt.locale().toString(value)
        apiKey: "ocppi"
        editableItem: SpinBox {
            from: 0
            to: 3600
        }
    }

    EditValueItem {
        text: qsTr("Clock aligned data interval:")
        valueText: Qt.locale().toString(value)
        apiKey: "ocppai"
        editableItem: SpinBox {
            from: 0
            to: 3600
        }
    }

    EditValueItem {
        text: qsTr("Dummy card id")
        apiKey: "ocppd"
        fullWidth: true
        editableItem: TextField {
            id: textField1
            property alias value: textField1.text
        }
    }

    GeneralOnOffSwitch {
        apiKey: "ocppr"
        text: qsTr("Rotate phases on charger")
    }

    GeneralOnOffSwitch {
        apiKey: "ocppao"
        text: qsTr("Allow Offline Tx For UnknownId")
    }

    GeneralOnOffSwitch {
        apiKey: "ocpplo"
        text: qsTr("Local Authorize Offline")
    }

    GeneralOnOffSwitch {
        apiKey: "ocppla"
        text: qsTr("Local Auth List Enabled")
    }

    // TODO MeterValuesCondition

    GeneralOnOffSwitch {
        apiKey: "ocppt"
        text: qsTr("Accept time from backend")
    }

    GeneralOnOffSwitch {
        apiKey: "ocppio"
        text: qsTr("Set as inoperable")
    }
}
