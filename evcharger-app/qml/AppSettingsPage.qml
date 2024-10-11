import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("App Settings")

    function backPressed() {
        return false
    }

    WhiteBox {
        Layout.fillWidth: true

        GridLayout {
            anchors.fill: parent
            columns: 2

            Text {
                text: qsTr("Number of app instances:")
                font.bold: true
                wrapMode: Text.Wrap
            }

            SpinBox {
                value: theSettings.numberOfAppInstances
                onValueModified: theSettings.numberOfAppInstances = value
                from: 1
            }
        }
    }

    WhiteBox {
        Layout.fillWidth: true

        GridLayout {
            anchors.fill: parent
            columns: 2

            Text {
                text: qsTr("solalaweb key:")
                font.bold: true
                wrapMode: Text.Wrap
            }

            Button {
                text: theSettings.solalawebKey == "" ? qsTr("Select...") : qsTr("Replace...")
                onClicked: keyFileDialog.open()

                FileDialog {
                    id: keyFileDialog
                    fileMode: FileDialog.OpenFile
                    onAccepted: theSettings.loadSolalawebKey(selectedFile)
                }
            }

            Text {
                text: qsTr("solalaweb cert:")
                font.bold: true
                wrapMode: Text.Wrap
            }

            Button {
                text: theSettings.solalawebCert == "" ? qsTr("Select...") : qsTr("Replace...")
                onClicked: certFileDialog.open()

                FileDialog {
                    id: certFileDialog
                    fileMode: FileDialog.OpenFile
                    onAccepted: theSettings.loadSolalawebCert(selectedFile)
                }
            }

            CheckDelegate {
                Layout.columnSpan: 2
                Layout.fillWidth: true

                text: qsTr("Show solalaweb:")
                checked: theSettings.showSolalaweb
                onClicked: theSettings.showSolalaweb = checked
            }
        }
    }
}
