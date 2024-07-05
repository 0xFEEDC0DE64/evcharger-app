import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("General")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Name")
        component: "NamePage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Switch Language")
        component: "SwitchLanguagePage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Notifications")
        component: "NotificationsPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Date and time")
        component: "DateAndTimePage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("LED")
        component: "LedPage.qml"
        visible: ledApiKeyValueHelper.exists
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Controller")
        component: "ControllerPage.qml"
        visible: controllerApiKeyValueHelper.exists
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Display settings")
        component: "DisplaySettingsPage.qml"
        visible: displayApiKeyValueHelper.exists
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Reboot")
        component: "RebootPage.qml"
    }
}
