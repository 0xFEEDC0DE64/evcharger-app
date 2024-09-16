import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("Firmware")

    WhiteBox {
        Layout.fillWidth: true

        GridLayout {
            anchors.fill: parent
            columns: 2

            Text {
                text: qsTr("Running version:")
                font.bold: true
            }

            ApiKeyValueItem {
                apiKey: "fwv"
                id: runningVersion
            }

            Text {
                text: qsTr("Details:")
                font.bold: true
            }

            Text {
                Layout.fillWidth: true

                ApiKeyValueHelper {
                    id: runningVersionDetails
                    deviceConnection: theDeviceConnection
                    apiKey: "apd"
                }

                text: JSON.stringify(runningVersionDetails.value, null, 4)
            }

            Text {
                text: qsTr("Recommended version:")
                font.bold: true
            }

            ApiKeyValueItem {
                id: recommendedVersion
                apiKey: "onv"
            }
        }
    }

    WhiteBox {
        Layout.fillWidth: true

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: qsTr("Update:")
                }

                ComboBox {
                    id: firmwareSelector

                    ApiKeyValueHelper {
                        id: availableUrls
                        deviceConnection: theDeviceConnection
                        apiKey: "ocu"
                    }

                    Layout.fillWidth: true
                    model: availableUrls.value

                    delegate: ItemDelegate {
                        text: modelData
                        background: Rectangle {
                            color: recommendedVersion.value == modelData ? "lightgreen" : modelData.includes(runningVersion.value) ? "lightyellow" : "white"
                        }
                        width: parent.width
                    }
                }

                SendMessageHelper {
                    id: startFirmwareUpdate
                    deviceConnection: theDeviceConnection
                }

                Button {
                    text: qsTr("Start")

                    onClicked: startFirmwareUpdate.sendMessage({
                        type: "otaCloud",
                        firmware: firmwareSelector.currentValue
                    })
                }

                BusyIndicator {
                    visible: startFirmwareUpdate.pending
                }

                RequestStatusText {
                    request: startFirmwareUpdate
                }
            }

            RowLayout {
                Layout.fillWidth: true

                SendMessageHelper {
                    id: abortFirmwareUpdate
                    deviceConnection: theDeviceConnection
                }

                Button {
                    text: qsTr("Abort")

                    onClicked: abortFirmwareUpdate.sendMessage({
                        type: "abortFwUpdate"
                    })
                }

                BusyIndicator {
                    visible: abortFirmwareUpdate.pending
                }

                RequestStatusText {
                    request: abortFirmwareUpdate
                }
            }

            RowLayout {
                Layout.fillWidth: true

                SendMessageHelper {
                    id: switchAppPartition
                    deviceConnection: theDeviceConnection
                }

                Button {
                    text: qsTr("Switch partition")

                    onClicked: switchAppPartition.sendMessage({
                        type: "switchAppPartition"
                    })
                }

                BusyIndicator {
                    visible: switchAppPartition.pending
                }

                RequestStatusText {
                    request: switchAppPartition
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2

                Text {
                    text: qsTr("Update status:")
                    font.bold: true
                }

                Text {
                    Layout.fillWidth: true

                    ApiKeyValueHelper {
                        id: updateStatus
                        deviceConnection: theDeviceConnection
                        apiKey: "ocs"
                    }

                    text: {
                        switch (updateStatus.value)
                        {
                        case 0: return "Idle"
                        case 1: return "Updating"
                        case 2: return "Failed"
                        case 3: return "Succeeded"
                        case 4: return "NotReady"
                        case 5: return "Verifying"
                        default: return updateStatus.value
                        }
                    }
                }

                Text {
                    text: qsTr("Update progress:")
                    font.bold: true
                }

                ColumnLayout {
                    Text {
                        Layout.fillWidth: true

                        ApiKeyValueHelper {
                            id: updateProgress
                            deviceConnection: theDeviceConnection
                            apiKey: "ocp"
                        }

                        ApiKeyValueHelper {
                            id: updateLength
                            deviceConnection: theDeviceConnection
                            apiKey: "ocl"
                        }

                        text: updateProgress.value + " / " + updateLength.value
                    }

                    ProgressBar {
                        from: 0
                        to: updateLength.value ? updateLength.value : 0
                        value: updateProgress.value
                    }
                }

                Text {
                    text: qsTr("Update message:")
                    font.bold: true
                }

                ApiKeyValueItem {
                    apiKey: "ocm"
                }
            }
        }
    }
}
