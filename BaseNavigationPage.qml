import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Layout.fillWidth: true

    property alias title: titleText.text
    default property alias data: columnLayout.data
    property alias headerItems: headerLayout.data

    ColumnLayout {
        id: columnLayout

        anchors.fill: parent

        RowLayout {
            id: headerLayout

            Layout.fillWidth: true

            Button {
                text: qsTr("Back")
                visible: stackView.depth > 1
                onClicked: stackView.pop()
            }

            Text {
                Layout.fillWidth: true

                id: titleText

                font.pixelSize: 30
                font.bold: true
                wrapMode: Text.Wrap
            }
        }
    }
}
