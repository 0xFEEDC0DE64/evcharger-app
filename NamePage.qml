import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Name")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Name")
        component: "NamePage.qml"
    }

    EditValueItem {
        id: test
        text: qsTr("Name")
        apiKey: "fna"
        fullWidth: true
        editableItem: TextField {
            id: textField
            property alias value: textField.text
        }
    }
}
