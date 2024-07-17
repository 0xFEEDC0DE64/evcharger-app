import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

Loader {
    id: loader

    signal closeRequested()

    property alias url: theDeviceConnection.url
    property alias password: theDeviceConnection.password

    function backPressed() {
        return item.backPressed()
    }

    ListModel {
        id: collectedMessages

        function push(message) {
            if (collectedMessages.count >= 15)
                collectedMessages.remove(0);
            collectedMessages.append({message});
        }
    }

    DeviceConnection {
        id: theDeviceConnection

        Component.onCompleted: start()

        settings: theSettings

        onLogMessage: (message) => collectedMessages.push(message)

        onAuthRequired: {
            passwordError.visible = false;
            passwordDialog.open();
        }
        onAuthError: function(message) {
            passwordError.visible = true;
            passwordError.text = message;
            passwordDialog.open();
        }
        onAuthImpossible: authImpossibleDialog.open()
    }

    sourceComponent: Component {
        ConnectingScreen {
            anchors.fill: parent

            onConnected: loader.sourceComponent = mainScreen;
        }
    }

    Component {
        id: mainScreen

        MainScreen {
            onCloseRequested: loader.closeRequested()
        }
    }

    CenteredDialog {
        id: passwordDialog

        title: qsTr("Password required")
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        onAccepted: theDeviceConnection.sendAuth(passwordInput.text)
        onRejected: loader.close()

        contentItem: GridLayout {
            property int minimumInputSize: 120

            id: grid

            columns: 2

            Text {
                id: passwordError

                Layout.columnSpan: 2
                color: "red"
            }

            Text {
                text: qsTr("Password:")
                Layout.alignment: Qt.AlignLeft | Qt.AlignBaseline
            }

            TextField {
                id: passwordInput
                focus: true
                Layout.fillWidth: true
                Layout.minimumWidth: grid.minimumInputSize
                Layout.alignment: Qt.AlignLeft | Qt.AlignBaseline
                placeholderText: qsTr("Password")
                echoMode: TextInput.PasswordEchoOnEdit
                onAccepted: passwordDialog.accept();
            }
        }
    }

    CenteredDialog {
        id: authImpossibleDialog

        title: qsTr("Authentication impossible!")
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        onAccepted: loader.close()
        onRejected: loader.close()

        contentItem: Text {
            text: qsTr("To use this password remotely a password has to be setup first. This can be done over the AccessPoint.");
        }
    }
}
