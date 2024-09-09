import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
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
        ToolBar {
            id: toolBar

            Layout.fillWidth: true

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

                            ApiKeyValueHelper {
                                id: errApiKeyHelper
                                deviceConnection: theDeviceConnection
                                apiKey: "err"
                            }

                            text: {
                                switch (carApiKeyHelper.value)
                                {
                                case 0: return qsTr("Internal error")
                                case 1: return qsTr("No car connected")
                                case 2: return qsTr("Car is charging")
                                case 3: return qsTr("Connecting to your car...")
                                case 4: return qsTr("Charging completed")
                                case 5: return qsTr("Unknown error %0").arg(errApiKeyHelper.value)
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
                            deviceConnection: theDeviceConnection
                            apiKey: "typ"
                        }

                        ApiKeyValueHelper {
                            id: isgo
                            deviceConnection: theDeviceConnection
                            apiKey: "isgo"
                        }

                        source: {
                            if (devicetype.value == "go-eCharger_V5" ||
                                devicetype.value == "go-eCharger_V4")
                            {
                                if (isgo.value)
                                    return "images/geminiFlex.png"
                                else
                                    return "images/geminiFix.png"
                            } else if (devicetype.value == "wattpilot_V2") {
                                return "images/wattpilot.png"
                            } else if (devicetype.value == "go-eCharger" ||
                                       devicetype.value == "wattpilot") {
                                return "images/homeFix.png"
                            } else if (devicetype.value == "go-eCharger_Phoenix") {
                                return "images/phoenix.png"
                            }

                            return "material-icons/grid_guides.svg"
                        }
                    }
                }

                StartStopButton {
                    Layout.fillWidth: true
                    deviceConnection: theDeviceConnection
                }

                ApiKeyValueHelper {
                    id: logicMode
                    deviceConnection: theDeviceConnection
                    apiKey: "lmo"
                }

                SelectLogicModeItem {
                    Layout.fillWidth: true
                }

                NavigationItem {
                    ApiKeyValueHelper {
                        id: priceLimitHelper
                        deviceConnection: theDeviceConnection
                        apiKey: "awp"
                    }

                    visible: logicMode.value == 4
                    iconSource: "material-icons/grid_guides.svg"
                    title: qsTr("Price limit")
                    description: qsTr("%0 ct/kWh").arg(Qt.locale().toString(priceLimitHelper.value, 'f', 1))
                    component: "SetPriceLimitPage.qml"
                }

                NavigationItem {
                    visible: logicMode.value == 5
                    iconSource: "material-icons/grid_guides.svg"
                    title: qsTr("Daily trip")
                    description: qsTr("By %0 with %1").arg("08:00").arg(qsTr("%0 km").arg(100))
                    component: "DailyTripPage.qml"
                }

                ApiKeyValueHelper {
                    id: requestedCurrent
                    deviceConnection: theDeviceConnection
                    apiKey: "amp"
                }

                ApiKeyValueHelper {
                    id: phaseSwitchMode
                    deviceConnection: theDeviceConnection
                    apiKey: "psm"
                }

                NavigationItem {
                    iconSource: "material-icons/grid_guides.svg"
                    title: qsTr("Charging speed")
                    description: qsTr("%0 & %1")
                        .arg(qsTr("%0 Ampere").arg(requestedCurrent.value))
                        .arg((function(){
                            switch (phaseSwitchMode.value)
                            {
                            case 0: return qsTr("Automatic phase selection");
                            case 1: return qsTr("1-phase");
                            case 2: return qsTr("3-phase");
                            case 3: return qsTr("Unknown phase selection (%0)").arg(phaseSwitchMode.value);
                            }
                        })())
                    component: "ChargingSpeedPage.qml"
                }
            }
        }
    }
}
