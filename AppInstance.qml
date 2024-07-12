import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import EVChargerApp

Loader {
    id: loader

    sourceComponent: deviceList

    function backPressed() {
        return loader.item.backPressed()
    }

    DevicesModel {
        id: devicesModel

        settings: theSettings

        Component.onCompleted: start()
    }

    Component {
        id: deviceList

        DeviceListScreen {
            //onDeviceSelected: (url, password) => loader.setSource("DeviceScreen.qml", { url, password })
            onDeviceSelected: function(url, password) {
                loader.sourceComponent = deviceScreen
                loader.item.url = url;
                loader.item.password = password;
            }
        }
    }

    Component {
        id: deviceScreen

        DeviceScreen {
            onClose: loader.sourceComponent = deviceList
        }
    }
}
