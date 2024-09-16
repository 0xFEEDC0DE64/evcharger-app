import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

TabButton {
    id: control

    contentItem: Item {
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            //anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            Text {
                Layout.fillWidth: true
                text: control.text
                font: control.font
                horizontalAlignment: Text.AlignHCenter
            }
            RowLayout {
                Layout.fillHeight: true

                Item {
                    Layout.fillWidth: true
                }

                Image {
                    source: control.icon.source

                    fillMode: Image.PreserveAspectFit

                    width: 32
                    height: 32
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }
    }
}
