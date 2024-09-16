import QtQuick
import QtQuick.Layouts

StackLayout {
    id: root
    property int previousIndex: 0
    property var items: children
    property Item previousItem: items[previousIndex]
    property Item currentItem: items[currentIndex]

    Component.onCompleted: {
        previousIndex = currentIndex

        for(var i = 1; i < count; ++i) {
            children[i].opacity = 0
        }
    }

    Component {
        id: crossFader
        ParallelAnimation {
            property Item fadeOutTarget
            property Item fadeInTarget

            NumberAnimation {
                target: fadeOutTarget
                property: "opacity"
                to: 0
                duration: 300
            }

            NumberAnimation {
                target: fadeInTarget
                property: "opacity"
                to: 1
                duration: 300
            }
        }
    }

    onCurrentIndexChanged: {
        items = root.children

        if(previousItem && currentItem && (previousItem != currentItem)) {
            previousItem.visible = false
            currentItem.visible = true    
            var crossFaderAnim = crossFader.createObject(parent, {fadeOutTarget: previousItem, fadeInTarget: currentItem})
            crossFaderAnim.restart()
        }
        previousIndex = currentIndex
    }
}
