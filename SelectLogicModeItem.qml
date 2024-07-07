import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

WhiteBox {
    RowLayout {
        anchors.fill: parent

        ButtonGroup {
            buttons: parent.children
        }

        LogicModeButton {
            Layout.preferredWidth: parent.width / parent.children.length
            checked: true
            text: qsTr("Eco")
            icon.source: "icons/EcoModeFilled.svg"
            description: qsTr("Eco-friendly & cost effective")
        }

        LogicModeButton {
            Layout.preferredWidth: parent.width / parent.children.length
            text: qsTr("Basic")
            icon.source: "icons/EcoModeFilled.svg"
            description: qsTr("Basic charging")
        }

        LogicModeButton {
            Layout.preferredWidth: parent.width / parent.children.length
            text: qsTr("Daily trip")
            icon.source: "icons/EcoModeFilled.svg"
            description: qsTr("Specific energy and time")
        }
    }
}
