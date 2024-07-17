import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Set price limit")

    Text {
        Layout.fillWidth: true
        text: qsTr("Set a proper price limit for charging, so charging starts when the electricity price is below this limit. Also, you can see the charging forecast chart below based on the limit that you define.")
        wrapMode: Text.Wrap
    }

    EditValueItem {
        id: test
        text: qsTr("Price limit")
        valueText: qsTr("%0 ct/kWh").arg(test.value)
        apiKey: "awp"
        editableItem: DoubleSpinBox {
            from: -1000.
            to: 1000.
            stepSize: .1
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
