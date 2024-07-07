import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

StackView {
    id: stackView

    function backPressed() {
        if (depth > 1) {
            pop()
            return true
        }

        return false
    }

    initialItem: ColumnLayout {
        ToolBar {
            id: toolBar

            Layout.fillWidth: true

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

                        Text {
                            Layout.fillWidth: true

                            text: {
                                switch (carApiKeyHelper.value)
                                {
                                case 0: return qsTr("Internal error")
                                case 1: return qsTr("No car connected")
                                case 2: return qsTr("Car is charging")
                                case 3: return qsTr("Connecting to your car...")
                                case 4: return qsTr("Charging completed")
                                case 5: return qsTr("Unknown error %0").arg(0)
                                }
                            }
                            font.pixelSize: 20
                            font.bold: true
                            wrapMode: Text.Wrap
                        }

                        Text {
                            Layout.fillWidth: true

                            text: {
                                switch (carApiKeyHelper.value)
                                {
                                case 0: return null
                                case 1: return qsTr("Plug in the cable to start charging your car")
                                case 2: return "TODO duration"
                                case 3: return qsTr("Charger is connecting to your car, it usually takes a few seconds")
                                case 4: return qsTr("Let's go-e :)")
                                case 5: return null
                                }
                            }
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

                    Material.accent: Material.White

                    text: qsTr("Start")
                }

                ApiKeyValueHelper {
                    id: logicMode
                    deviceConnection: mainScreen.deviceConnection
                    apiKey: "lmo"
                }

                SelectLogicModeItem {
                    Layout.fillWidth: true
                }

                NavigationItem {
                    visible: logicMode.value == 4
                    iconSource: "material-icons/grid_guides.svg"
                    title: qsTr("Price limit")
                    description: qsTr("%0 ct/kWh").arg(0)
                    component: "SetPriceLimitPage.qml"
                }

                NavigationItem {
                    visible: logicMode.value == 5
                    iconSource: "material-icons/grid_guides.svg"
                    title: qsTr("Daily trip")
                    description: qsTr("By %0 with %1").arg("08:00").arg(qsTr("%0 km").arg(100))
                    component: "DailyTripPage.qml"
                }

                NavigationItem {
                    iconSource: "material-icons/grid_guides.svg"
                    title: qsTr("Charging speed")
                    description: qsTr("%0 Ampere & %1-phase").arg(0).arg(0)
                    component: "ChargingSpeedPage.qml"
                }
            }
        }
    }
}
