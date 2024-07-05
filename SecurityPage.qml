import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Security")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Cable")
        component: "CablePage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Access")
        component: "AccessPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Password")
        component: "PasswordPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Grid")
        component: "GridPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Ground check")
        component: "GroundCheckPage.qml"
    }
}
