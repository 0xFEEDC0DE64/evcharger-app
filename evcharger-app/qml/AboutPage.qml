import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

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
    GeneralOnOffSwitch {
        apiKey: "demo"
        text: qsTr("Enable demo mode")
        visible: true
    }
    WhiteItemDelegate {
        SendMessageHelper {
            id: setChargingColor
            deviceConnection: theDeviceConnection
        }

        text: qsTr("Set charging color to new")

        onClicked: setChargingColor.sendMessage({
            type: "setValue",
            key: "cch",
            value: "#FEFEFE"
        })

        BusyIndicator {
            visible: setChargingColor.pending
        }

        RequestStatusText {
            request: setChargingColor
        }
    }
}
