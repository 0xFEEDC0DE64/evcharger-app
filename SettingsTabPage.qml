import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

AnimatedStackView {
    id: stackView

    function backPressed() {
        if (depth > 1) {
            pop()
            return true
        }

        return false
    }

    initialItem: NavigationPage {
        title: qsTr("Settings")

        NavigationItem {
            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("Charging configuration")
            description: [
                qsTr("Charging Speed"),
                qsTr("kWh Limit"),
                qsTr("Daily Trip"),
                qsTr("Flexible energy tariff"),
                qsTr("PV Surplus")
            ].join(" • ")
            component: "ChargingConfigurationPage.qml"
            visible: carApiKeyHelper.exists
        }
        NavigationItem {
            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("Security")
            description: [
                qsTr("Cable"),
                qsTr("Access"),
                qsTr("Password"),
                qsTr("Grid"),
                qsTr("Ground check")
            ].join(" • ")
            component: "SecurityPage.qml"
            visible: carApiKeyHelper.exists
        }
        NavigationItem {
            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("Sensors Configuration")
            description: [
                qsTr("Sensors"),
                qsTr("Categories")
            ].join(" • ")
            component: "SensorsConfigurationPage.qml"
            visible: controllerApiKeyHelper.exists
        }
        NavigationItem {
            ApiKeyValueHelper {
                id: wifiStaApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "wen"
            }
            ApiKeyValueHelper {
                id: wifiApApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "wae"
            }
            ApiKeyValueHelper {
                id: ethernetApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "ee"
            }
            ApiKeyValueHelper {
                id: cloudApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "cwe"
            }
            ApiKeyValueHelper {
                id: ocppApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "ocppe"
            }
            ApiKeyValueHelper {
                id: mqttApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "mce"
            }

            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("Connection")
            description: [
                wifiStaApiKeyValueHelper.exists ? qsTr("Wi-Fi") : null,
                wifiApApiKeyValueHelper.exists ? qsTr("Hotspot") : null,
                ethernetApiKeyValueHelper.exists ? qsTr("Ethernet") : null,
                cloudApiKeyValueHelper.exists ? qsTr("Cloud") : null,
                ocppApiKeyValueHelper.exists ? qsTr("OCPP") : null,
                mqttApiKeyValueHelper.exists ? qsTr("MQTT") : null,
                qsTr("API Settings")
            ].filter(Boolean).join(" • ")
            component: "ConnectionPage.qml"
        }
        NavigationItem {
            ApiKeyValueHelper {
                id: ledApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "lbr"
            }
            ApiKeyValueHelper {
                id: controllerApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "ccd"
            }
            ApiKeyValueHelper {
                id: displayApiKeyValueHelper
                deviceConnection: mainScreen.deviceConnection
                apiKey: "dro"
            }

            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("General")
            description: [
                qsTr("Name"),
                qsTr("Switch Language"),
                qsTr("Notifications"),
                qsTr("Date and time"),
                ledApiKeyValueHelper.exists ? qsTr("LED") : null,
                controllerApiKeyValueHelper.exists ? qsTr("Controller") : null,
                displayApiKeyValueHelper.exists ? qsTr("Display settings") : null
            ].filter(Boolean).join(" • ")
            component: "GeneralPage.qml"
        }
        NavigationItem {
            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("About")
            description: [
                qsTr("Firmware"),
                qsTr("Hardware information"),
                qsTr("Licenses")
            ].join(" • ")
            component: "AboutPage.qml"
        }
    }
}
