import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("About")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Firmware")
        component: "FirmwarePage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Hardware information")
        component: "HardwareInformationPage.qml"
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Licenses")
        component: "LicensesPage.qml"
    }
}
