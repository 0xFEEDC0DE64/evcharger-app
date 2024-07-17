import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Scheduler day")

    TimeComponentLabel {
        id: openDialogLabel
        width: parent.width - 80
        anchors.centerIn: parent
        font.pixelSize: Qt.application.font.pixelSize * 8
        renderTypeQuality: Text.VeryHighRenderTypeQuality
        interactive: !timePickerDialog.opened

        text: Qt.formatTime(new Date(1970, 1, 1, timePickerDialog.hours, timePickerDialog.minutes), "hh:mm")

        onTapped: timePickerDialog.openWithMode(TimePicker.Mode.Hours)
    }

    ColumnLayout {
        // We always want the openDialogLabel to be centered in the window, not us.
        // For that reason, we use anchors rather than putting the root items into a ColumnLayout.
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: openDialogLabel.bottom
        anchors.topMargin: 24
        spacing: 12

        Switch {
            id: is24HourSwitch
            text: qsTr("24 Hour")
            checked: timePickerDialog.is24Hour
        }
        // Switch {
        //     id: darkThemeSwitch
        //     text: qsTr("Dark")
        // }
    }

    TimePickerDialog {
        id: timePickerDialog
        is24Hour: is24HourSwitch.checked

        onTimeAccepted: print("A time was chosen - do something here!")
    }
}
