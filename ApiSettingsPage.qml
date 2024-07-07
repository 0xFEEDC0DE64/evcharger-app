import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("API Settings")

    WhiteBox {
        Layout.fillWidth: true
        visible: localApi.exists

        ColumnLayout {
            anchors.fill: parent

            GeneralOnOffSwitch {
                id: localApi
                apiKey: "hai"
                text: qsTr("Allow access to local HTTP-Api v2")
            }

            Button {
                text: qsTr("API documentation")
            }

            RowLayout {
                Layout.fillWidth: true

                SendMessageHelper {
                    id: apiToken
                    deviceConnection: mainScreen.deviceConnection
                }

                Button {
                    text: qsTr("Generate token")
                    onClicked: apiToken.sendMessage({ type: "generateApiToken" })
                }

                BusyIndicator {
                    visible: apiToken.pending
                }

                Text {
                    Layout.fillWidth: true

                    visible: apiToken.response
                    text: {
                        if (!apiToken.response)
                            return ""
                        if (apiToken.response.success)
                            return qsTr("OK! token: %0").arg(apiToken.response.token)
                        else
                            return apiToken.response.message
                    }
                    wrapMode: Text.Wrap
                }
            }

            RowLayout {
                Layout.fillWidth: true

                ApiKeyValueHelper {
                    id: tokenSetup
                    deviceConnection: mainScreen.deviceConnection
                    apiKey: "hatv"
                }

                visible: tokenSetup.value

                SendMessageHelper {
                    id: abortFirmwareUpdate
                    deviceConnection: mainScreen.deviceConnection
                }

                Button {
                    text: qsTr("Clear API token")

                    onClicked: abortFirmwareUpdate.sendMessage({ type: "clearApiToken" })
                }

                BusyIndicator {
                    visible: abortFirmwareUpdate.pending
                }

                RequestStatusText {
                    Layout.fillWidth: true
                    request: abortFirmwareUpdate
                }
            }
        }
    }

    WhiteBox {
        Layout.fillWidth: true
        visible: cloudApi.exists

        ColumnLayout {
            anchors.fill: parent

            GeneralOnOffSwitch {
                id: cloudApi
                apiKey: "cae"
                text: qsTr("Enable cloud API")
            }

            ApiKeyValueHelper {
                id: cloudApiKey
                deviceConnection: mainScreen.deviceConnection
                apiKey: "cak"
            }

            Text {
                visible: cloudApiKey.exists
                text: qsTr("API key: %0").arg(cloudApiKey.value)
            }

            Button {
                text: qsTr("API documentation")
            }
        }
    }

    WhiteBox {
        Layout.fillWidth: true
        visible: gridApi.exists

        ColumnLayout {
            anchors.fill: parent

            GeneralOnOffSwitch {
                Layout.fillWidth: true
                id: gridApi
                apiKey: "gme"
                text: qsTr("Enable grid API")
            }

            ApiKeyValueHelper {
                id: gridApiKey
                deviceConnection: mainScreen.deviceConnection
                apiKey: "gmk"
            }

            Text {
                Layout.fillWidth: true
                visible: gridApiKey.exists
                text: qsTr("API key: %0").arg(gridApiKey.value)
            }

            Button {
                text: qsTr("API documentation")
            }
        }
    }

    WhiteBox {
        Layout.fillWidth: true
        visible: legacyApi.exists

        ColumnLayout {
            anchors.fill: parent

            GeneralOnOffSwitch {
                id: legacyApi
                apiKey: "hla"
                text: qsTr("Allow access to legacy HTTP-Api v1")
            }

            Button {
                text: qsTr("API documentation")
            }
        }
    }
}
