import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Flexible energy tariff")

    GeneralOnOffSwitch {
        apiKey: "ful"
        text: qsTr("Charge with flexible energy tariff")
    }

    GeneralOnOffSwitch {
        apiKey: "awe"
        text: qsTr("Charge with flexible energy tariff")
    }

    NavigationItem {
        ApiKeyValueHelper {
            id: priceLimitHelper
            deviceConnection: theDeviceConnection
            apiKey: "awp"
        }

        visible: logicMode.value == 4
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Price limit")
        description: qsTr("%0 ct/kWh").arg(Qt.locale().toString(priceLimitHelper.value, 'f', 1))
        component: Component {
            SetPriceLimitPage {
            }
        }
    }
}
