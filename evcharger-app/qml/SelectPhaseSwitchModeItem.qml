import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteBox {
    ColumnLayout {
        anchors.fill: parent

        SetValueHelper {
            id: valueChanger
            deviceConnection: theDeviceConnection
            apiKey: "psm"
            onResponseChanged: {
                automaticButton.checked = Qt.binding(() => automaticButton.selectedMode)
                singlePhaseButton.checked = Qt.binding(() => singlePhaseButton.selectedMode)
                threePhaseButton.checked = Qt.binding(() => threePhaseButton.selectedMode)
            }
        }

        Text {
            Layout.fillWidth: true

            font.bold: true
            text: qsTr("Phase switching")
        }

        TabBar {
            id: tabBar

            Layout.fillWidth: true

            Component.onCompleted: {
                background.color = "#EEEEEE"
                background.radius = 5
            }

            TabButton {
                id: automaticButton
                property bool selectedMode: phaseSwitchMode.value == 0
                checked: selectedMode
                text: qsTr("Automatic")
                onClicked: valueChanger.setValue(0)
            }
            TabButton {
                id: singlePhaseButton
                property bool selectedMode: phaseSwitchMode.value == 1
                checked: selectedMode
                text: qsTr("1-Phase")
                onClicked: valueChanger.setValue(1)
            }
            TabButton {
                id: threePhaseButton
                property bool selectedMode: phaseSwitchMode.value == 2
                checked: selectedMode
                text: qsTr("3-Phase")
                onClicked: valueChanger.setValue(2)
            }
        }
    }
}
