import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import EVChargerApp

AnimatedStackView {
    id: stackView

    function backPressed() {
        if (stackView.currentItem.backPressed())
            return true
        if (depth > 1) {
            pop()
            return true
        }
        return false
    }

    initialItem: DeviceListScreen {
        id: deviceListScreen
        onDeviceSelected: (url, password) => stackView.push(deviceScreenComponent, { url, password })
    }

    Component {
        id: deviceScreenComponent

        DeviceScreen {
            onCloseRequested: stackView.pop(deviceListScreen)
        }
    }
}
