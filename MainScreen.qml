import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

ColumnLayout {
    id: mainScreen

    required property DeviceConnection deviceConnection

    function backPressed() {
        if (stackLayout.currentItem.item.backPressed())
            return true
        if (stackLayout.currentIndex != 0) {
            stackLayout.currentIndex = 0
            stackLayout.currentIndex = Qt.binding(() => tabBar.currentIndex)
            return true
        }
        loader.close()
        return true
    }

    ApiKeyValueHelper {
        id: rebootTime
        deviceConnection: mainScreen.deviceConnection
        apiKey: "rbt"
    }

    function formatDuration(duration) {
        duration = Math.floor(duration)

        const wasNegative = duration < 0;
        if (wasNegative)
            duration = -duration;

        const milliseconds = duration%1000;
        duration-=milliseconds;
        duration/=1000;

        const seconds = duration%60;
        duration-=seconds;
        duration/=60;

        const minutes = duration%60;
        duration-=minutes;
        duration/=60;

        const hours = duration%24;

        return (wasNegative ? qsTr('%0 ago') : qsTr('in %0'))
            .arg(
                (hours < 10 ? '0' : '') + hours + ':' +
                (minutes < 10 ? '0' : '') + minutes + ':' +
                (seconds < 10 ? '0' : '') + seconds + '.' +
                (milliseconds < 100 ? '0' : '') + (milliseconds < 10 ? '0' : '') + milliseconds)
            ;
    }

    ApiKeyValueHelper {
        id: carApiKeyHelper
        deviceConnection: mainScreen.deviceConnection
        apiKey: "car"
    }

    ApiKeyValueHelper {
        id: controllerApiKeyHelper
        deviceConnection: mainScreen.deviceConnection
        apiKey: "ccp"
    }

    ListModel {
        id: modelBoth

        ListElement {
            text: qsTr("Charger")
            icon: "icons/ChargerV4.svg"
            source: "ChargerTabPage.qml"
        }
        ListElement {
            text: qsTr("Eco")
            icon: "icons/EcoModeFilled.svg"
            source: "EcoTabPage.qml"
        }
        ListElement {
            text: qsTr("Controller")
            icon: "icons/Controller.svg"
            source: "ControllerTabPage.qml"
        }
        ListElement {
            text: qsTr("Infromations")
            icon: "icons/Charts.svg"
            source: "InformationsTabPage.qml"
        }
        ListElement {
            text: qsTr("Settings")
            icon: "material-icons/settings.svg"
            source: "SettingsTabPage.qml"
        }
    }

    ListModel {
        id: modelCharger

        ListElement {
            text: qsTr("Charger")
            icon: "icons/ChargerV4.svg"
            source: "ChargerTabPage.qml"
        }
        ListElement {
            text: qsTr("Eco")
            icon: "icons/EcoModeFilled.svg"
            source: "EcoTabPage.qml"
        }
        ListElement {
            text: qsTr("Infromations")
            icon: "icons/Charts.svg"
            source: "InformationsTabPage.qml"
        }
        ListElement {
            text: qsTr("Settings")
            icon: "material-icons/settings.svg"
            source: "SettingsTabPage.qml"
        }
    }

    ListModel {
        id: modelController

        ListElement {
            text: qsTr("Controller")
            icon: "icons/Controller.svg"
            source: "ControllerTabPage.qml"
        }
        ListElement {
            text: qsTr("Infromations")
            icon: "icons/Charts.svg"
            source: "InformationsTabPage.qml"
        }
        ListElement {
            text: qsTr("Settings")
            icon: "material-icons/settings.svg"
            source: "SettingsTabPage.qml"
        }
    }

    ListModel {
        id: modelNone

        ListElement {
            text: qsTr("Infromations")
            icon: "icons/Charts.svg"
            source: "InformationsTabPage.qml"
        }
        ListElement {
            text: qsTr("Settings")
            icon: "material-icons/settings.svg"
            source: "SettingsTabPage.qml"
        }
    }

    property ListModel theModel: {
        if (carApiKeyHelper.exists) {
            if (controllerApiKeyHelper.exists) {
                return modelBoth
            } else {
                return modelCharger
            }
        } else {
            if (controllerApiKeyHelper.exists) {
                return modelController
            } else {
                return modelNone
            }
        }
    }

    StackLayout {
        id: stackLayout
        Layout.fillWidth: true
        Layout.fillHeight: true

        currentIndex: tabBar.currentIndex
        property Item currentItem: children[currentIndex]

        Repeater {
            model: theModel

            delegate: Loader {
                source: model.source
            }
        }
    }

    TabBar {
        id: tabBar
        Layout.fillWidth: true

        currentIndex: stackLayout.currentIndex
        contentHeight: 56

        Repeater {
            model: theModel

            delegate: VerticalTabButton {
                text: model.text
                //width: tabBar.width / tabBar.count
                icon.source: model.icon
            }
        }
    }
}
