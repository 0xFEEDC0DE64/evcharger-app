import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

BaseNavigationPage {
    default property alias data: columnLayout.data

    Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentHeight: columnLayout.height
        clip: true

        ColumnLayout {
            id: columnLayout
            width: parent.width - 10
            x: 5
            spacing: 5
        }
    }
}
