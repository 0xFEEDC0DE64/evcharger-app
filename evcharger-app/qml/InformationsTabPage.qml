import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import EVChargerApp

ScrollableTabPage {
    id: page

    function backPressed() {
        return false
    }

    TitleText {
        text: qsTr("Informations")
    }

    Text {
        id: statusText
        text: qsTr("Idle")
    }

    ApiKeyValueHelper {
        id: dataApiKeyValueHelper
        deviceConnection: theDeviceConnection
        apiKey: "data"
    }

    QtObject {
        property var xhr: undefined
        property bool requestAgain: false

        property var parsed: typeof dataApiKeyValueHelper.value === 'string' || dataApiKeyValueHelper.value instanceof String ?
                                 JSON.parse(dataApiKeyValueHelper.value) : undefined
        property var url: parsed ? parsed.url + "&title=title&chartTitle=chartTitle&scale=1&width=" + (page.width-30) + "&app_id=1&&lang=de" : undefined
        onUrlChanged: {
            if (!url)
                return;

            if (xhr) {
                console.log('enqueued new request')
                requestAgain = true
                return
            }

            console.log('started new request')
            xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                    statusText.text = qsTr("HEADERS_RECEIVED");
                } else if(xhr.readyState === XMLHttpRequest.LOADING) {
                    statusText.text = qsTr("LOADING");
                } else if(xhr.readyState === XMLHttpRequest.DONE) {
                    try {
                        var object = JSON.parse(xhr.responseText.toString());

                        imagesRepeater.model = object.images;

                        statusText.text = qsTr("DONE!" + ('images' in object ? ' images' : '') + ('chartData' in object ? ' chartData' : ''));
                    } catch (e) {
                        statusText.text = qsTr("DONE, but exception: " + e);
                    }

                    xhr = undefined
                    if (requestAgain) {
                        requestAgain = false
                        onUrlChanged()
                    }
                }
            }
            statusText.text = qsTr("Request started...");
            xhr.open("GET", url);
            xhr.send();
        }
    }

    Repeater {
        id: imagesRepeater
        visible: false
        Layout.fillWidth: true

        Image {
            Layout.fillWidth: true
            x: -30
            source: "data:image/svg+xml;utf8," + modelData
        }
    }

    Repeater {
        model: 5

        ChartView {
            title: "Line"
            Layout.fillWidth: true
            Layout.preferredHeight: page.height * 0.75
            antialiasing: true

            LineSeries {
                name: "LineSeries"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
            }
        }
    }

    OpenLinkButton {
        ApiKeyValueHelper {
            id: downloadsLink
            deviceConnection: theDeviceConnection
            apiKey: "dll"
        }

        visible: downloadsLink.exists
        text: qsTr("Download informations")
        url: downloadsLink.value
    }
}
