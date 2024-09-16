import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

WhiteItemDelegate {
    id: navigationItem

    property color color
    property Component component
    property var componentArgs: undefined

    Layout.fillWidth: true

    Component.onCompleted: {
        contentItem.children[0].color = navigationItem.color
    }

    onClicked: stackView.push(navigationItem.component)
}
