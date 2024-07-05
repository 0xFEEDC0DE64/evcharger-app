import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    signal connected

    required property DeviceConnection deviceConnection

    function backPressed() {
        close()
        return true
    }

    Connections {
        target: deviceConnection
        onFullStatusReceived: connected()
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

        delegate: Label {
            text: message
        }

        onCountChanged: positionViewAtEnd()
    }

    Button {
        text: qsTr("Cancel")

        onClicked: close()
    }
}
