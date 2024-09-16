import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Connection")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Wi-Fi")
        component: Component {
            WiFiPage {
            }
        }
        visible: wifiStaApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Cellular")
        component: Component {
            CellularPage {
            }
        }
        visible: cellularApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Hotspot")
        component: Component {
            HotspotPage {
            }
        }
        visible: wifiApApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Ethernet")
        component: Component {
            EthernetPage {
            }
        }
        visible: ethernetApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Cloud")
        component: Component {
            CloudPage {
            }
        }
        visible: cloudApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("OCPP")
        component: Component {
            OcppPage {
            }
        }
        visible: ocppApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("MQTT")
        component: Component {
            MqttPage {
            }
        }
        visible: mqttApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("API Settings")
        component: Component {
            ApiSettingsPage {
            }
        }
    }
}
