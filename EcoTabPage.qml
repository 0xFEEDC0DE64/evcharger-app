import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

AnimatedStackView {
    id: stackView

    function backPressed() {
        if (depth > 1) {
            pop()
            return true
        }

        return false
    }

    initialItem: NavigationPage {
        title: qsTr("Eco")

        NavigationItem {
            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("Flexible energy tariff") // TODO show On Off
            component: "FlexibleEnergyTariffPage.qml"
        }

        NavigationItem {
            iconSource: "material-icons/grid_guides.svg"
            title: qsTr("PV Surplus") // TODO show On Off
            component: "PvSurplusPage.qml"
        }

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
                    text: qsTr("About eco")
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
                            text: qsTr("Flexible energy tariff")
                            wrapMode: Text.Wrap
                        }

                        Text {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            text: qsTr("We offer to charge your car during periods of low electricity price, If you have an electricity contract based on flexible energy tariffs.")
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
                            text: qsTr("PV surplus energy")
                            wrapMode: Text.Wrap
                        }

                        Text {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            text: qsTr("By connecting a PV system and a controller to your charger, you can charge your EV particularly cheaply and use clean energy at the same time.")
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }
    }
}
