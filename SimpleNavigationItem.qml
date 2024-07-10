import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ItemDelegate {
    id: navigationItem

    property color color
    property string component
    property var componentArgs: undefined

    Layout.fillWidth: true

    Component.onCompleted: {
        background.radius = 5
        background.color = 'white'
        contentItem.children[0].color = navigationItem.color
    }

    onClicked: stackView.push(navigationItem.component, navigationItem.componentArgs)
}
