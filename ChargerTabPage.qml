import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

Page {
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

            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ApiKeyValueHelper {
                    id: friendlyName
                    deviceConnection: mainScreen.deviceConnection
                    apiKey: "fna"
                }

                text: friendlyName.value
                color: "white"
                verticalAlignment: Text.AlignVCenter
            }

            Button {
                Layout.fillHeight: true

                text: qsTr("Devices")
                onClicked: loader.close()
            }
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: columnLayout.implicitHeight
        clip: true

        ColumnLayout {
            id: columnLayout
            width: flickable.width
            spacing: 5

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        text: qsTr("No car connected")
                        font.pixelSize: 20
                        font.bold: true
                        wrapMode: Text.Wrap
                    }

                    Text {
                        Layout.fillWidth: true

                        text: qsTr("Connect the cable to charge your car")
                        wrapMode: Text.Wrap
                    }
                }

                Image {
                    Layout.preferredWidth: parent.width / 4
                    Layout.preferredHeight: paintedHeight

                    fillMode: Image.PreserveAspectFit

                    ApiKeyValueHelper {
                        id: devicetype
                        deviceConnection: mainScreen.deviceConnection
                        apiKey: "typ"
                    }

                    ApiKeyValueHelper {
                        id: isgo
                        deviceConnection: mainScreen.deviceConnection
                        apiKey: "isgo"
                    }

                    source: {
                        if (devicetype.value == 'go-eCharger_V5' ||
                            devicetype.value == 'go-eCharger_V4')
                        {
                            if (isgo.value)
                                return "images/geminiFlex.png"
                            else
                                return "images/geminiFix.png"
                        } else if (devicetype.value == 'wattpilot_V2') {
                            return "images/wattpilot.png"
                        } else if (devicetype.value == 'go-eCharger' ||
                                   devicetype.value == 'wattpilot') {
                            return "images/homeFix.png"
                        } else if (devicetype.value == 'go-eCharger_Phoenix') {
                            return "images/phoenix.png"
                        }

                        return "material-icons/grid_guides.svg"
                    }
                }
            }

            Button {
                Layout.fillWidth: true

                text: qsTr("Start")
            }

            ButtonGroup {
                buttons: column.children
            }

            RowLayout {
                id: column
                Layout.fillWidth: true

                Button {
                    Layout.fillWidth: true
                    checked: true
                    checkable: true
                    text: qsTr("Eco")
                    display: AbstractButton.TextUnderIcon
                }

                Button {
                    Layout.fillWidth: true
                    checkable: true
                    text: qsTr("Basic")
                    display: AbstractButton.TextUnderIcon
                }

                Button {
                    Layout.fillWidth: true
                    checkable: true
                    text: qsTr("Daily trip")
                    display: AbstractButton.TextUnderIcon
                }
            }
        }
    }
}
