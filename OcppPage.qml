import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("OCPP")

    GeneralOnOffSwitch {
        apiKey: "ocppe"
    }

    Text {
        text: "TODO"

        Layout.fillHeight: true
    }
}
