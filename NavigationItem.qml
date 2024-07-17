import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

WhiteItemDelegate {
    id: navigationItem

    property alias iconSource: icon.source
    property alias title: titleText.text
    property string description
    property string component

    Layout.fillWidth: true

    implicitWidth: row.implicitWidth
    implicitHeight: Math.max(row.implicitHeight, 50)

    onClicked: stackView.push(navigationItem.component)

    RowLayout {
        id: row

        anchors.fill: parent

        Image {
            id: icon
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
        }

        ColumnLayout {
            Layout.fillWidth: true

            Text {
                id: titleText

                Layout.fillWidth: true

                wrapMode: Text.Wrap
                font.bold: true
            }

            Text {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: navigationItem.description
                visible: text != ""
            }
        }

        Text {
            text: ">"
        }
    }
}
