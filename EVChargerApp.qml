import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import EVChargerApp

ApplicationWindow {
    id: window

    width: 320
    height: 480
    visible: true
    title: qsTr("EVcharger App")
    color: "#F3F2F7"

    AppSettings {
        id: theSettings
    }

    FontLoader {
        id: materialIcons
        source: "ui-icons/MaterialIcons-Regular.ttf"
    }

    SwipeView {
        id: view

        anchors.fill: parent

        currentIndex: indicator.currentIndex

        Repeater {
            model: theSettings.numberOfAppInstances

            AppInstance {
                width: view.width
            }
        }
    }

    PageIndicator {
        id: indicator

        visible: view.count > 1

        count: view.count
        currentIndex: view.currentIndex

        anchors.top: view.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function backPressed() {
        if (view.currentItem.backPressed())
            return true

        if (view.currentIndex > 0) {
            view.currentIndex = 0
            view.currentIndex = Qt.binding(() => indicator.currentIndex)
            return true
        }

        return false
    }

    onClosing: (close) => {
        if (backPressed())
            close.accepted = false
    }
}
