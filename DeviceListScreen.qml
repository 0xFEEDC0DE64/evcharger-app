import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

StackView {
    id: stackView

    signal deviceSelected(url: string, password: string)

    function backPressed() {
        if (depth > 1) {
            pop()
            return true
        }
        return false
    }

    // pushEnter: Transition {
    //     PropertyAnimation {
    //         property: "opacity"
    //         from: 0
    //         to:1
    //         duration: 200
    //     }
    // }
    // pushExit: Transition {
    //     PropertyAnimation {
    //         property: "opacity"
    //         from: 1
    //         to:0
    //         duration: 200
    //     }
    // }
    // popEnter: Transition {
    //     PropertyAnimation {
    //         property: "opacity"
    //         from: 0
    //         to:1
    //         duration: 200
    //     }
    // }
    // popExit: Transition {
    //     PropertyAnimation {
    //         property: "opacity"
    //         from: 1
    //         to:0
    //         duration: 200
    //     }
    // }

    initialItem: BaseNavigationPage {
        id: page
        title: qsTr("Device list")

        CloudUrlsModel {
            id: cloudUrlsModel
        }

        DevicesModel {
            id: devicesModel

            settings: theSettings

            Component.onCompleted: start()
        }

        headerItems: [
            Button {
                text: qsTr("App Settings")
                icon.source: "material-icons/settings.svg"
                display: AbstractButton.IconOnly

                onClicked: stackView.push(appSettingsPage)

                Component {
                    id: appSettingsPage

                    AppSettingsPage {
                    }
                }
            }
        ]

        ListView {
            id: listView
            model: devicesModel

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10
            contentX: -15

            ScrollBar.vertical: ScrollBar {
                interactive: false
            }

            footer: Item {
                height: 75
            }

            section.property: "saved"
            section.criteria: ViewSection.FullString
            section.delegate: Component {
                id: sectionHeading
                Text {
                    width: ListView.view.width - 30
                    height: implicitHeight + 50
                    bottomPadding: 10

                    verticalAlignment: Text.AlignBottom
                    wrapMode: Text.Wrap

                    required property bool section

                    text: section ? qsTr("My devices") : qsTr("Found devices")
                    font.bold: true
                    font.pixelSize: 20
                }
            }

            delegate: SwipeDelegate {
                id: delegate
                checkable: true
                width: ListView.view.width - 30

                required property int index

                required property string name
                required property string serial
                required property string manufacturer
                required property string deviceType
                required property string friendlyName
                required property string password
                required property bool saved
                required property string hostName
                required property string ip

                Component.onCompleted: {
                    background.color = "white"
                    background.radius = 5
                }

                swipe.enabled: saved

                swipe.right: Label {
                    id: deleteLabel
                    text: qsTr("Delete")
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.right: parent.right

                    SwipeDelegate.onClicked: {
                        listView.model.removeRow(delegate.index)
                        swipe.close()
                        delegate.checked = false;
                    }

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                    }
                }

                contentItem: ColumnLayout {
                    RowLayout {
                        Image {
                            height: parent.height
                            //Layout.fillHeight: true
                            source: {
                                if (delegate.deviceType == 'go-eCharger_V5' ||
                                    delegate.deviceType == 'go-eCharger_V4' ||
                                    delegate.deviceType == 'wattpilot_V2')
                                {
                                    return "icons/ChargerV4.svg"
                                } else if (delegate.deviceType == 'go-eCharger' ||
                                           delegate.deviceType == 'wattpilot') {
                                    return "icons/ChargerV3.svg"
                                } else if (delegate.deviceType == 'go-eCharger_Phoenix') {
                                    return "icons/Charger.svg"
                                } else if (delegate.deviceType.includes('controller')) {
                                    return "icons/Controller.svg"
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Label {
                                Layout.fillWidth: true
                                text: delegate.friendlyName
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Label {
                                Layout.fillWidth: true
                                text: qsTr("Serial Number %0").arg(delegate.serial);
                            }
                        }
                    }

                    GridLayout {
                        id: grid
                        visible: false

                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 10

                        Label {
                            text: qsTr("Manufacturer:")
                            Layout.leftMargin: 60
                        }

                        Label {
                            text: delegate.manufacturer
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Label {
                            text: qsTr("Device Type:")
                            Layout.leftMargin: 60
                        }

                        Label {
                            text: delegate.deviceType
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Label {
                            text: qsTr("Host Name:")
                            Layout.leftMargin: 60
                        }

                        Label {
                            text: delegate.hostName
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Label {
                            text: qsTr("Ip:")
                            Layout.leftMargin: 60
                        }

                        Label {
                            text: delegate.ip
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Button {
                            enabled: delegate.ip != ""

                            text: qsTr("Connect local")
                            onClicked: deviceSelected("ws://" + delegate.ip + "/ws", delegate.password)
                        }

                        Button {
                            property var cloudUrl: {
                                for (let i = 0; i < cloudUrlsModel.count; ++i) {
                                    const entry = cloudUrlsModel.get(i);
                                    if (delegate.manufacturer === entry.manufacturer &&
                                        delegate.deviceType.includes(entry.deviceType)) {
                                        return entry.url;
                                    }
                                }
                                return null;
                            }

                            enabled: cloudUrl !== null

                            text: qsTr("Connect cloud")
                            onClicked: deviceSelected(cloudUrl + delegate.serial, delegate.password)
                        }
                    }
                }

                states: [
                    State {
                        name: "expanded"
                        when: delegate.checked

                        PropertyChanges {
                            // TODO: When Qt Design Studio supports generalized grouped properties, change to:
                            //       grid.visible: true
                            // qmllint disable Quick.property-changes-parsed
                            target: grid
                            visible: true
                        }
                    }
                ]
            }
        }

        Button {
            parent: page
            anchors {
                right: parent.right
                rightMargin: 10
                bottom: parent.bottom
                bottomMargin: 25
            }

            text: qsTr("Add or setup device")
            icon.source: "material-icons/add.svg"

            font.pointSize: 12
            font.bold: true

            highlighted: true
            Material.accent: Material.Blue

            display: listView.contentY < 20 ? AbstractButton.TextBesideIcon : AbstractButton.IconOnly

            onClicked: stackView.push(addDeviceScreen)

            Component {
                id: addDeviceScreen

                AddDeviceScreen {
                }
            }
        }
    }
}
