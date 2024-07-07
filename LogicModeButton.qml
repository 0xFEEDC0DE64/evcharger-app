import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

RadioButton {
    id: control

    checkable: true
    display: AbstractButton.TextUnderIcon

    required property string description

    indicator: Rectangle {
        color: "blue"
        width: 10
        height: 10
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: control.checked
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        Text {
            Layout.fillWidth: true
            text: control.text
            color: control.checked ? "blue" : "black"
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            wrapMode: Text.Wrap
        }
        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            text: control.description
            wrapMode: Text.Wrap
        }
    }
}
