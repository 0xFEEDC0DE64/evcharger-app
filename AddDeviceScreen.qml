import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

NavigationPage {
    function backPressed() {
        return false
    }

    title: qsTr("Setup or add device")

    WhiteBox {
        Layout.fillWidth: true

        ColumnLayout {
            id: localLayout

            anchors.fill: parent

            Text {
                text: qsTr("Add via local connection or AP:")
            }

            RowLayout {
                Layout.fillWidth: true

                TextField {
                    id: manualUrl

                    Layout.fillWidth: true

                    placeholderText: qsTr("Local url")
                    text: "ws://10.128.250.181/ws"
                    // validator: RegularExpressionValidator { regularExpression: /^wss?://.*/ }
                    onAccepted: connectLocalButton.clicked()
                }

                Button {
                    id: connectLocalButton
                    text: qsTr("Connect")
                    onClicked: deviceSelected(manualUrl.text, "")
                }
            }
        }
    }

    Item {
        Layout.preferredHeight: 50
    }

    WhiteBox {
        Layout.fillWidth: true

        ColumnLayout {
            id: cloudLayout

            anchors.fill: parent
            spacing: 5

            Text {
                text: qsTr("Add via cloud:")
            }

            RowLayout {
                Layout.fillWidth: true

                TextField {
                    id: cloudSerial

                    Layout.fillWidth: true

                    placeholderText: qsTr("Cloud Serial")
                    text: "000000"
                    onTextChanged: {
                        const serial = Number(text);
                        for (let i = 0; i < cloudUrlsModel.count; ++i) {
                            const entry = cloudUrlsModel.get(i);
                            if (serial >= entry.minSerial && serial <= entry.maxSerial) {
                                cloudType.currentIndex = i;
                                break;
                            }
                        }
                    }
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhFormattedNumbersOnly
                    validator: RegularExpressionValidator { regularExpression: /^[0-9]{6,}$/ }
                    onAccepted: connectCloudButton.clicked()
                }

                ComboBox {
                    id: cloudType

                    textRole: "text"
                    valueRole: "url"

                    model: cloudUrlsModel
                }

                Button {
                    id: connectCloudButton
                    text: qsTr("Connect")
                    onClicked: deviceSelected(cloudType.currentValue + cloudSerial.text, "")
                }
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
