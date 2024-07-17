import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

ColumnLayout {
    signal connected

    function backPressed() {
        return false
    }

    Connections {
        target: theDeviceConnection
        function onFullStatusReceived() {
            connected()
        }
    }

    Text {
        text: qsTr("Trying to reach device...")
    }

    BusyIndicator {
        Layout.fillWidth: true

        running: true
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: collectedMessages
        clip: true

        delegate: Text {
            text: message
        }

        onCountChanged: positionViewAtEnd()
    }

    Button {
        text: qsTr("Cancel")

        onClicked: stackView.pop()
    }
}
