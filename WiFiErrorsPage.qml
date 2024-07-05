import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

BaseNavigationPage {
    property ApiKeyValueHelper wifiErrorLog

    title: qsTr("Wi-Fi Errors")

    // Item {
    //     id: theAboveList
    //     // component exists only to complete the example supplied in the question
    // }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: trues

        model: wifiErrorLog.value
        spacing: 5
        clip: true
        verticalLayoutDirection: ListView.BottomToTop

        // anchors
        // {
        //     left: parent.left
        //     top: theAboveList.bottom
        //     right: parent.right
        //     bottom: parent.bottom
        // }
        // header: Item {}
        // onContentHeightChanged: {
        //     if (contentHeight < height) {
        //         headerItem.height += (height - contentHeight)
        //     }
        //     currentIndex = count-1
        //     positionViewAtEnd()
        // }

        delegate: Rectangle {
            required property var modelData
            property var theModelData: modelData

            color: "white"
            radius: 5

            width: listView.width
            height: gridLayout.implicitHeight

            property var properties: [ qsTr("Timestamp:"), qsTr("SSID:"), qsTr("BSSID:"), qsTr("Reason:") ]

            GridLayout {
                id: gridLayout
                anchors.fill: parent

                Repeater {
                    model: properties

                    Text {
                        required property int index
                        required property string modelData

                        text: modelData
                        Layout.row: index
                        Layout.column: 0
                    }
                }
                Repeater {
                    model: properties

                    Text {
                        Layout.fillWidth: true

                        required property int index

                        text: index == 0 ? formatDuration((theModelData[index] > 5.184e+9 ? theModelData[index] / 1000 : theModelData[index]) - rebootTime.value) : theModelData[index]
                        Layout.row: index
                        Layout.column: 1
                    }
                }
            }
        }
    }
}
