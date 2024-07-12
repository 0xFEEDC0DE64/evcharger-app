import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

BaseNavigationPage {
    property ApiKeyValueHelper wifiScanResult

    title: qsTr("Wi-Fi Scan Result")

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: wifiScanResult.value
        spacing: 5
        clip: true

        delegate: WhiteBox {
            required property var modelData
            property var theModelData: modelData

            width: listView.width

            GridLayout {
                anchors.fill: parent
                columns: 2

                Text {
                    text: qsTr("SSID:")
                    font.bold: true
                }

                Text {
                    text: modelData.ssid
                }

                Text {
                    text: qsTr("Authmode:")
                    font.bold: true
                }

                Text {
                    text: {
                        switch (modelData.encryptionType)
                        {
                        case 0: return qsTr("OPEN")
                        case 1: return qsTr("WEP")
                        case 2: return qsTr("WPA_PSK")
                        case 3: return qsTr("WPA2_PSK")
                        case 4: return qsTr("WPA_WPA2_PSK")
                        case 5: return qsTr("WPA2_ENTERPRISE")
                        case 6: return qsTr("WPA3_PSK")
                        case 7: return qsTr("WPA2_WPA3_PSK")
                        case 8: return qsTr("WAPI_PSK")
                        case 9: return qsTr("OWE")
                        case 10: return qsTr("WPA3_ENT_192")
                        case 11: return qsTr("WPA3_EXT_PSK")
                        case 12: return qsTr("WPA3_EXT_PSK_MIXED_MODE")
                        }
                        return modelData.encryptionType
                    }
                }

                function wiFiCipherToString(cipher) {
                    const names = ['NONE', 'WEP40', 'WEP104', 'TKIP', 'CCMP', 'TKIP_CCMP', 'AES_CMAC128', 'SMS4', 'GCMP', 'GCMP256', 'AES_GMAC128', 'AES_GMAC256', 'UNKNOWN'];

                    if (cipher >= 0 && cipher < names.length)
                        return names[cipher];

                    return cipher;
                }

                Text {
                    text: qsTr("Pairwise cipher:")
                    font.bold: true
                }

                Text {
                    text: parent.wiFiCipherToString("f" in modelData ? modelData.f[0] : modelData.pairwiseCipher)
                }

                Text {
                    text: qsTr("Group cipher:")
                    font.bold: true
                }

                Text {
                    text: parent.wiFiCipherToString("f" in modelData ? modelData.f[1] : modelData.groupCipher)
                }

                Text {
                    text: qsTr("RSSI:")
                    font.bold: true
                }

                Text {
                    text: modelData.rssi
                }

                Text {
                    text: qsTr("Channel:")
                    font.bold: true
                }

                Text {
                    text: modelData.channel
                }

                Text {
                    text: qsTr("BSSID:")
                    font.bold: true
                }

                Text {
                    text: modelData.bssid
                }
            }
        }
    }
}
