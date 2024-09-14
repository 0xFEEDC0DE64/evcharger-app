import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

ToolBar {
    id: toolBar

    signal closeRequested()

    background: Rectangle {
        color: "lightblue"
    }

    RowLayout {
        anchors.fill: parent

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ApiKeyValueHelper {
                id: friendlyName
                deviceConnection: theDeviceConnection
                apiKey: "fna"
            }

            text: friendlyName.value
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            Layout.fillHeight: true

            text: qsTr("Devices")
            onClicked: closeRequested()
        }
    }
}
