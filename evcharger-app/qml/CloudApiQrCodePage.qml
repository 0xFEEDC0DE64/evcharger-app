import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    title: qsTr("3rdparty integrations")

    ApiKeyValueHelper {
        id: serial
        deviceConnection: theDeviceConnection
        apiKey: "sse"
    }

    ApiKeyValueHelper {
        id: cloudApiKey
        deviceConnection: theDeviceConnection
        apiKey: "cak"
    }

    property string integrationUrl: qsTr("https://device.go-e.io/%0?t=%1").arg(serial.value).arg(cloudApiKey.value)

    QrCode {
        Layout.fillWidth: true
        fillMode: Image.PreserveAspectFit
        anchors.leftMargin: 50
        anchors.rightMargin: 50

        visible: (typeof serial.value === 'string' || serial.value instanceof String) && serial.value != "" &&
                 (typeof cloudApiKey.value === 'string' || cloudApiKey.value instanceof String) && cloudApiKey.value != ""
        content: integrationUrl
    }

    OpenLinkButton {
        text: qsTr("Open integrations page")
        url: integrationUrl
    }
}
