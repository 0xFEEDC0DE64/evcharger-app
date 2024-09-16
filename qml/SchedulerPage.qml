import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Scheduler")

    WhiteBox {
        Layout.fillWidth: true

        ColumnLayout {
            anchors.fill: parent

            Image {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                source: "material-icons/grid_guides.svg"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                Layout.fillWidth: true
                font.pointSize: 20
                font.bold: true
                text: qsTr("About Schedule")
                wrapMode: Text.Wrap
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                Layout.fillWidth: true
                text: qsTr("Customize your charging routine on workdays, Saturdays, and Sundays. Define specific time slots for charging or blocking to perfectly align with your weekly schedule. Schedule can only start charging if all other functions like eco or access settings allow charging.")
                wrapMode: Text.Wrap
                verticalAlignment: Text.AlignVCenter
            }

            RowLayout {
                Layout.fillWidth: true

                Image {
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    source: "material-icons/grid_guides.svg"
                    fillMode: Image.PreserveAspectFit
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        font.bold: true
                        text: qsTr("Charging schedule")
                        wrapMode: Text.Wrap
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        text: qsTr("go-e Charger will exclusively charge your car during the time slots you set, and won't charge for the rest of the time.")
                        wrapMode: Text.Wrap
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Image {
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    source: "material-icons/grid_guides.svg"
                    fillMode: Image.PreserveAspectFit
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        font.bold: true
                        text: qsTr("Blocking schedule")
                        wrapMode: Text.Wrap
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        text: qsTr("go-e Charger will block charging your car during the time slots you set, but it will charge your car for the rest of the time.")
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }

    Text {
        text: qsTr("Workdays")
        font.bold: true
        font.pointSize: 15
        height: implicitHeight + 30
    }

    SimpleNavigationItem {
        text: qsTr("Create workdays schedule")
        color: "blue"
        component: Component {
            SchedulerDayPage {
                day: 0
            }
        }
    }

    Text {
        text: qsTr("Saturdays")
        font.bold: true
        font.pointSize: 15
        height: implicitHeight + 30
    }

    SimpleNavigationItem {
        text: qsTr("Create saturdays schedule")
        color: "blue"
        component: Component {
            SchedulerDayPage {
                day: 1
            }
        }
    }

    Text {
        text: qsTr("Sundays")
        font.bold: true
        font.pointSize: 15
        height: implicitHeight + 30
    }

    SimpleNavigationItem {
        text: qsTr("Create sundays schedule")
        color: "blue"
        component: Component {
            SchedulerDayPage {
                day: 2
            }
        }
    }
}
