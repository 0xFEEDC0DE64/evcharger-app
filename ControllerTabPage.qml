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

        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: columnLayout.implicitHeight
            clip: true

            ColumnLayout {
                id: columnLayout
                width: flickable.width - 30
                x: 15
                spacing: 5

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
                    GridLayout {
                        colums: 3

                        Pane {
                            Component.onCompleted: {
                                background.color = "white"
                                background.radius = 5
                            }
                        }
                        Pane {
                            Component.onCompleted: {
                                background.color = "white"
                                background.radius = 5
                            }
                        }
                        Pane {
                            Component.onCompleted: {
                                background.color = "white"
                                background.radius = 5
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
<
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
}
