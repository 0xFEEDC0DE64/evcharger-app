import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteBox {
    id: control

    RowLayout {
        anchors.fill: parent

        SetValueHelper {
            id: valueChanger
            deviceConnection: theDeviceConnection
            apiKey: "lmo"
            onResponseChanged: {
                ecoButton.checked = Qt.binding(() => ecoButton.selectedMode)
                basicButton.checked = Qt.binding(() => basicButton.selectedMode)
                dailyTripButton.checked = Qt.binding(() => dailyTripButton.selectedMode)
            }
        }

        ButtonGroup {
            buttons: parent.children
        }

        LogicModeButton {
            id: ecoButton
            Layout.preferredWidth: parent.width / parent.children.length
            property bool selectedMode: logicMode.value == 4
            checked: selectedMode
            text: qsTr("Eco")
            icon.source: "icons/EcoModeFilled.svg"
            description: qsTr("Eco-friendly & cost effective")
            onClicked: {
                if (selectedMode)
                    tabBar.setCurrentIndex(1)
                else
                    valueChanger.setValue(4)
            }
        }

        LogicModeButton {
            id: basicButton
            Layout.preferredWidth: parent.width / parent.children.length
            property bool selectedMode: logicMode.value == 3
            checked: selectedMode
            text: qsTr("Basic")
            icon.source: "icons/EcoModeFilled.svg"
            description: qsTr("Basic charging")
            onClicked: valueChanger.setValue(3)
        }

        LogicModeButton {
            id: dailyTripButton
            Layout.preferredWidth: parent.width / parent.children.length
            property bool selectedMode: logicMode.value == 5
            checked: selectedMode
            text: qsTr("Daily trip")
            icon.source: "icons/EcoModeFilled.svg"
            description: qsTr("Specific energy and time")
            onClicked: {
                if (selectedMode)
                    stackView.push(dailyTripPageComponent)
                else
                    valueChanger.setValue(5)
            }

            Component {
                id: dailyTripPageComponent

                DailyTripPage {
                }
            }
        }

        BusyIndicator {
            parent: control
            anchors.left: parent.left
            anchors.top: parent.top
            visible: valueChanger.pending
        }
    }
}
