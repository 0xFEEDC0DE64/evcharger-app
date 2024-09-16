import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("PV Surplus")

    GeneralOnOffSwitch {
        apiKey: "fup"
        text: qsTr("Charging with PV surplus")
    }
}
