import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("About")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Firmware")
        component: Component {
            FirmwarePage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Hardware information")
        component: Component {
            HardwareInformationPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Licenses")
        component: Component {
            LicensesPage {
            }
        }
    }
}
