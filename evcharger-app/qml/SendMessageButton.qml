import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

RowLayout {
    id: rowLayout

    required property string messageType
    required property string text

    SendMessageHelper {
        id: helper
        deviceConnection: theDeviceConnection
    }

    Button {
        text: rowLayout.text

        onClicked: helper.sendMessage({
            type: messageType
        })
    }

    BusyIndicator {
        visible: helper.pending
    }

    RequestStatusText {
        request: helper
    }
}
