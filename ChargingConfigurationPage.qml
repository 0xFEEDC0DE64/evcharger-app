import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Charging configuration")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Charging Speed")
        component: "ChargingSpeedPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("kWh Limit")
        component: "KwhLimitPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Daily Trip")
        component: "DailyTripPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Flexible energy tariff")
        component: "FlexibleEnergyTariffPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("PV Surplus")
        component: "PvSurplusPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Load Balancing")
        component: "LoadBalancingPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Scheduler")
        component: "SchedulerPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Current Levels")
        component: "CurrentLevelsPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Car")
        component: "CarPage.qml"
    }
}
