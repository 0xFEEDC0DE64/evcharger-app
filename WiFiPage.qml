import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Wi-Fi")

    WiFiOnOffSwitch {

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
                deviceConnection: mainScreen.deviceConnection
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
    }

    Button {
        ApiKeyValueHelper {
            id: wifiScanResult
            deviceConnection: mainScreen.deviceConnection
            apiKey: "scan"
        }

        text: qsTr("(%0) Wi-Fi Scan").arg(wifiScanResult.value == null ? 0 : wifiScanResult.value.length)
        onClicked: stackView.push(wiFiScanPageComponent, {wifiScanResult} )
        enabled: wifiScanResult.value != null

        Component {
            id: wiFiScanPageComponent

            WiFiScanPage {
            }
        }
    }

    Button {
        ApiKeyValueHelper {
            id: wifiErrorLog
            deviceConnection: mainScreen.deviceConnection
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

    Item {
        Layout.fillHeight: true
    }
}
