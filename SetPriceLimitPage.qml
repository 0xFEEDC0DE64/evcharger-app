import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Set price limit")

    Text {
        Layout.fillWidth: true
        text: qsTr("Set a proper price limit for charging, so charging starts when the electricity price is below this limit. Also, you can see the charging forecast chart below based on the limit that you define.")
        wrapMode: Text.Wrap
    }

    ItemDelegate {
        Layout.fillWidth: true
        Component.onCompleted: {
            background.color = "white"
            background.radius = 5
        }

        contentItem: RowLayout {
            Text {
                text: qsTr("Price limit")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.bold: true
            }

            Text {
                text: qsTr("%0 ct/kWh").arg(0)
            }

            Text {
                text: ">"
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
