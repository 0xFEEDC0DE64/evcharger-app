import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Connection")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Wi-Fi")
        component: "WiFiPage.qml"
        visible: wifiStaApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Hotspot")
        component: "HotspotPage.qml"
        visible: wifiApApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Ethernet")
        component: "EthernetPage.qml"
        visible: ethernetApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("OCPP")
        component: "OcppPage.qml"
        visible: ocppApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Cloud")
        component: "CloudPage.qml"
        visible: cloudApiKeyValueHelper.exists
    }

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("API Settings")
        component: "ApiSettingsPage.qml"
    }
}
