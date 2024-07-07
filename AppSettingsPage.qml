import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("App Settings")

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: gridLayout.implicitHeight
        color: "white"
        radius: 5

        GridLayout {
            id: gridLayout
            columns: 2

            Label {
                text: qsTr("Number of app instances:")
                font.bold: true
            }

            SpinBox {
                value: theSettings.numberOfAppInstances
                onValueModified: theSettings.numberOfAppInstances = value
                from: 1
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: gridLayout2.implicitHeight
        color: "white"
        radius: 5

        GridLayout {
            id: gridLayout2
            columns: 2

            Label {
                text: qsTr("solalaweb key:")
                font.bold: true
            }

            Button {
                text: {
                    console.log('solalawebKey', theSettings.solalawebKey);
                    return theSettings.solalawebKey == "" ? qsTr("Select...") : qsTr("Replace...")
                }
                onClicked: keyFileDialog.open()

                FileDialog {
                    id: keyFileDialog
                    fileMode: FileDialog.OpenFile
                    onAccepted: theSettings.loadSolalawebKey(selectedFile)
                }
            }

            Label {
                text: qsTr("solalaweb cert:")
                font.bold: true
            }

            Button {
                text: {
                    console.log('solalawebCert', theSettings.solalawebCert);
                    return theSettings.solalawebCert == "" ? qsTr("Select...") : qsTr("Replace...")
                }
                onClicked: certFileDialog.open()

                FileDialog {
                    id: certFileDialog
                    fileMode: FileDialog.OpenFile
                    onAccepted: theSettings.loadSolalawebCert(selectedFile)
                }
            }
        }
    }
}
