import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

AnimatedStackView {
    id: stackView

    signal closeRequested()

    function backPressed() {
        if (depth > 1) {
            pop()
            return true
        }

        return false
    }

    initialItem: ColumnLayout {
        DeviceHeaderBar {
            Layout.fillWidth: true

            onCloseRequested: stackView.closeRequested()
        }

        ScrollableTabPage {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        Layout.fillWidth: true
                        width: 100

                        text: qsTr("Connected")
                        font.pixelSize: 20
                        font.bold: true
                        wrapMode: Text.Wrap
                    }
                }

                Image {
                    Layout.preferredWidth: parent.width / 3
                    Layout.preferredHeight: paintedHeight

                    fillMode: Image.PreserveAspectFit

                    source: "images/controller.png"
                }
            }

            WhiteBox {
                Layout.fillWidth: true
                Layout.preferredHeight: gridLayout.implicitHeight + 20

                GridLayout {
                    id: gridLayout
                    anchors.fill: parent
                    columns: 3

                    ApiKeyValueHelper {
                        id: categoryNames
                        deviceConnection: theDeviceConnection
                        apiKey: "ccn"
                    }

                    ApiKeyValueHelper {
                        id: categoryPowers
                        deviceConnection: theDeviceConnection
                        apiKey: "ccp"
                    }

                    Repeater {
                        model: categoryNames.value

                        Pane {
                            property var power: categoryPowers.value[index]
                            visible: power !== null

                            Layout.fillWidth: true
                            Layout.preferredWidth: gridLayout.width / 3
                            Layout.preferredHeight: 75

                            Component.onCompleted: {
                                background.color = "grey"
                                background.radius = 5
                            }

                            ColumnLayout {
                                id: columnLayout
                                anchors.fill: parent

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: power !== null ? qsTr("%0W").arg(power) : ""
                                }
                            }
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true

                text: "Controller TODO"
            }

            Text {
                Layout.fillWidth: true

                text: "Controller TODO"
            }
        }
    }
}
