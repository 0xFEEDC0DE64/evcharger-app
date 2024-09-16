import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Charging configuration")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Charging Speed")
        component: Component {
            ChargingSpeedPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("kWh Limit")
        component: Component {
            KwhLimitPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Daily Trip")
        component: Component {
            DailyTripPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Flexible energy tariff")
        component: Component {
            FlexibleEnergyTariffPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("PV Surplus")
        component: Component {
            PvSurplusPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Load Balancing")
        component: Component {
            LoadBalancingPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Scheduler")
        component: Component {
            SchedulerPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Current Levels")
        component: Component {
            CurrentLevelsPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Car")
        component: Component {
            CarPage {
            }
        }
    }
}
