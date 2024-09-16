import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("General")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Name")
        component: Component {
            NamePage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Switch Language")
        component: Component {
            SwitchLanguagePage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Notifications")
        component: Component {
            NotificationsPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Date and time")
        component: Component {
            DateAndTimePage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("LED")
        component: Component {
            LedPage {
            }
        }
        visible: ledApiKeyValueHelper.exists
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Controller")
        component: Component {
            ControllerPage {
            }
        }
        visible: controllerApiKeyValueHelper.exists
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Display settings")
        component: Component {
            DisplaySettingsPage {
            }
        }
        visible: displayApiKeyValueHelper.exists
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Reboot")
        component: Component {
            RebootPage {
            }
        }
    }
}
