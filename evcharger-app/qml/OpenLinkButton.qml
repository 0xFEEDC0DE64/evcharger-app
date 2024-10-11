import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    required property string url

    icon.name: "open-in-new"
    icon.source: "material-icons/open_in_new.svg"

    onClicked: Qt.openUrlExternally(url)
}
