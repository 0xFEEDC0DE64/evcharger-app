import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Name")

    EditValueItem {
        text: qsTr("Name")
        apiKey: "fna"
        fullWidth: true
        editableItem: TextField {
            id: textField
            property alias value: textField.text
        }
    }
}
