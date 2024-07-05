import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("API Settings")

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: localApiLayout.implicitHeight
        visible: localApi.exists

        ColumnLayout {
            id: localApiLayout
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

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: cloudApiLayout.implicitHeight
        visible: cloudApi.exists

        ColumnLayout {
            id: cloudApiLayout
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

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: gridApiLayout.implicitHeight
        visible: gridApi.exists

        ColumnLayout {
            id: gridApiLayout
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

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: legacyApiLayout.implicitHeight
        visible: legacyApi.exists

        ColumnLayout {
            id: legacyApiLayout
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
