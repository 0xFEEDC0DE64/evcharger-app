import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

WhiteItemDelegate {
    property alias descriptionText: descriptionText.text
    property alias valueText: valueText.text

    Layout.fillWidth: true

    contentItem: RowLayout {
        Text {
            id: descriptionText
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            font.bold: true
        }

        Text {
            id: valueText
        }

        Text {
            text: ">"
        }
    }

    onClicked: dialog.open()

    CenteredDialog {
        id: dialog

        title: qsTr("Password required")
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        contentItem: SpinBox {

        }

        // onAccepted: theDeviceConnection.sendAuth(passwordInput.text)
        // onRejected: loader.close()
    }
}
