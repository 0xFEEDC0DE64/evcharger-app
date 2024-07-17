import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

Page {
    signal closeRequested()

    function backPressed() {
        return false
    }

    header: ToolBar {
        id: toolBar

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

    Flickable {
        anchors.fill: parent

        ColumnLayout {
            Layout.fillWidth: true

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        //Layout.fillWidth: true
                        width: 100

                        text: qsTr("Connected")
                        font.pixelSize: 20
                        font.bold: true
                        wrapMode: Text.Wrap
                    }
                }

                Image {
                    Layout.fillHeight: true
                    // width: 200
                    // height: 200
                    Layout.preferredWidth: 100
                    fillMode: Image.PreserveAspectFit

                    source: "images/controller.png"
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: "Controller TODO"
            }
        }
    }
}
