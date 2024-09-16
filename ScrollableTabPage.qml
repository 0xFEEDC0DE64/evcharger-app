import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Flickable {
    default property alias data: columnLayout.data

    id: flickable
    Layout.fillWidth: true
    Layout.fillHeight: true
    contentHeight: columnLayout.implicitHeight
    clip: true

    ColumnLayout {
        id: columnLayout
        width: flickable.width - 30
        x: 15
        spacing: 5
    }
}
