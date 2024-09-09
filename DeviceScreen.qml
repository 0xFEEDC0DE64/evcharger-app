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
        if (connectionDisturbed.visible) {
            closeRequested()
            return true
        }
        else
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
            onCloseRequested: {
                connectionDisturbed.close()
                loader.closeRequested()
            }

            Connections {
                target: theDeviceConnection

                function onShowDisturbed() {
                    connectionDisturbed.open()
                }
                function onHideDisturbed() {
                    connectionDisturbed.close()
                }
            }
        }
    }

    CenteredDialog {
        id: passwordDialog

        title: qsTr("Password required")
        standardButtons: Dialog.Ok | Dialog.Cancel
        focus: true
        modal: true

        onAccepted: theDeviceConnection.sendAuth(passwordInput.text)
        onRejected: loader.closeRequested()

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
        standardButtons: Dialog.Ok
        focus: true
        modal: true

        onAccepted: loader.closeRequested()
        onRejected: loader.closeRequested()

        contentItem: Text {
            text: qsTr("To use this password remotely a password has to be setup first. This can be done over the AccessPoint.");
        }
    }

    Popup {
        id: connectionDisturbed

        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay

        // x: 100
        // y: 100
        // width: 200
        // height: 300

        modal: true
        focus: true

        closePolicy: Popup.NoAutoClose

        contentItem: Text {
            text: qsTr("Connection disturbed")
            wrapMode: Text.Wrap
        }
    }
}
