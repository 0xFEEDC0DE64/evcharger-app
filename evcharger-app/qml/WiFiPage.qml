import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Wi-Fi")

    ConfirmingOnOffSwitch {
        apiKey: "wen"
        dialogTitle: qsTr("Are you sure?")
        dialogText: qsTr("Disabling Wi-Fi could make your device unreachable from your local homenetwork or the cloud!")
    }

    GridLayout {
        columns: 2

        Text {
            text: qsTr("Status:")
        }

        Text {
            Layout.fillWidth: true

            ApiKeyValueHelper {
                id: staStatus
                deviceConnection: theDeviceConnection
                apiKey: "wst"
            }

            text: {
                switch (staStatus.value)
                {
                case 0: return "IDLE_STATUS"
                case 1: return "NO_SSID_AVAIL"
                case 2: return "SCAN_COMPLETED"
                case 3: return "CONNECTED"
                case 4: return "CONNECT_FAILED"
                case 5: return "CONNECTION_LOST"
                case 6: return "DISCONNECTED"
                case 7: return "CONNECTING"
                case 8: return "DISCONNECTING"
                case 9: return "NO_SHIELD"
                case 10: return "WAITING_FOR_IP"
                default: return staStatus.value
                }
            }
        }

        Text {
            text: qsTr("Scan-Status:")
        }

        Text {
            Layout.fillWidth: true

            ApiKeyValueHelper {
                id: scanStatus
                deviceConnection: theDeviceConnection
                apiKey: "scas"
            }

            text: {
                switch (scanStatus.value)
                {
                case 0: return "None"
                case 1: return "Scanning"
                case 2: return "Finished"
                case 3: return "Failed"
                default: return scanStatus.value
                }
            }
        }

        Text {
            text: qsTr("Scan-Age:")
        }

        Text {
            Layout.fillWidth: true

            ApiKeyValueHelper {
                id: scanAgeStatus
                deviceConnection: theDeviceConnection
                apiKey: "scaa"
            }

            text: scanAgeStatus.value != null ? formatDuration(scanAgeStatus.value - rebootTime.value) : null
        }
    }

    RowLayout {
        SendMessageButton {
            Layout.fillWidth: true
            text: qsTr("Trigger scan")
            messageType: "wifiScan"
        }

        Button {
            ApiKeyValueHelper {
                id: wifiScanResult
                deviceConnection: theDeviceConnection
                apiKey: "scan"
            }

            text: qsTr("(%0) Scan Result").arg(wifiScanResult.value == null ? 0 : wifiScanResult.value.length)
            onClicked: stackView.push(wiFiScanPageComponent, {wifiScanResult} )
            enabled: wifiScanResult.value != null

            Component {
                id: wiFiScanPageComponent

                WiFiScanPage {
                }
            }
        }
    }

    Button {
        ApiKeyValueHelper {
            id: wifiErrorLog
            deviceConnection: theDeviceConnection
            apiKey: "wsl"
        }

        text: qsTr("(%0) Wi-Fi Errors").arg(wifiErrorLog.value == null ? 0 : wifiErrorLog.value.length)
        onClicked: stackView.push(wiFiErrorsPageComponent, {wifiErrorLog} )
        enabled: wifiErrorLog.value != null

        Component {
            id: wiFiErrorsPageComponent

            WiFiErrorsPage {
            }
        }
    }

    EditValueItem {
        text: qsTr("Min RSSI")
        valueText: Qt.locale().toString(value)
        apiKey: "wsmr"
        editableItem: SpinBox {
            from: -100
            to: 0
        }
    }

    GeneralOnOffSwitch {
        apiKey: "wspc"
        text: qsTr("Pmf capable")
    }

    GeneralOnOffSwitch {
        apiKey: "wspr"
        text: qsTr("Pmf required")
    }
}
