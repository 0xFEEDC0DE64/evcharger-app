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

            OpenLinkButton {
                text: qsTr("API documentation")
                url: qsTr("https://github.com/goecharger/go-eCharger-API-v2/blob/main/http-en.md")
            }

            RowLayout {
                Layout.fillWidth: true

                SendMessageHelper {
                    id: apiToken
                    deviceConnection: theDeviceConnection
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
                    deviceConnection: theDeviceConnection
                    apiKey: "hatv"
                }

                visible: tokenSetup.value

                SendMessageHelper {
                    id: abortFirmwareUpdate
                    deviceConnection: theDeviceConnection
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
                deviceConnection: theDeviceConnection
                apiKey: "cak"
            }

            Text {
                visible: cloudApiKey.exists
                text: qsTr("API key: %0").arg(cloudApiKey.value)
            }

            OpenLinkButton {
                text: qsTr("API documentation")
                url: qsTr("https://github.com/goecharger/go-eCharger-API-v2/blob/main/cloudapi-en.md")
            }

            Button {
                text: qsTr("3rdparty integrations (QR-Code)")
                onClicked: stackView.push(cloudApiQrCodePage)

                Component {
                    id: cloudApiQrCodePage
                    CloudApiQrCodePage {
                    }
                }
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
                deviceConnection: theDeviceConnection
                apiKey: "gmk"
            }

            Text {
                Layout.fillWidth: true
                visible: gridApiKey.exists
                text: qsTr("API key: %0").arg(gridApiKey.value)
            }

            OpenLinkButton {
                text: qsTr("API documentation")
                url: qsTr("https://github.com/goecharger/go-eCharger-API-v2/blob/main/gridapi-en.md")
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

            OpenLinkButton {
                text: qsTr("API documentation")
                url: qsTr("https://github.com/goecharger/go-eCharger-API-v1/blob/master/go-eCharger%20API%20v1%20EN.md")
            }
        }
    }
}
