import QtQuick

ListModel {
    ListElement {
        text: qsTr("V2")
        url: "wss://app.v2.go-e.io/"
        manufacturer: "go-e"
        deviceType: "has-no-mdns"
        minSerial: 0
        maxSerial: 49999
    }
    ListElement {
        text: qsTr("Wattpilot")
        url: "wss://app.wattpilot.io/app/"
        manufacturer: "fronius"
        deviceType: "wattpilot"
        minSerial: 10000000
        maxSerial: 99999999
    }
    ListElement {
        text: qsTr("go-eCharger")
        url: "wss://app.v3.go-e.io/"
        manufacturer: "go-e"
        deviceType: "go-eCharger"
        minSerial: 50000
        maxSerial: 499999
    }
    ListElement {
        text: qsTr("go-eController")
        url: "wss://app.controller.go-e.io/"
        manufacturer: "go-e"
        deviceType: "controller"
        minSerial: 900000
        maxSerial: 999999
    }
    ListElement {
        text: qsTr("Solalaweb")
        url: "wss://solalaweb.com/"
        manufacturer: "go-e"
        deviceType: "has-no-mdns"
    }
}
