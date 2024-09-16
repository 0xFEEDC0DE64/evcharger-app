import QtQuick
import QtQuick.Controls

Item {
    id: doubleSpinBox

    property int decimals: 2
    property real value: 0.0
    property real from: 0.0
    property real to: 100.0
    property real stepSize: 1.0

    SpinBox {
        property real factor: Math.pow(10, decimals)

        id: spinbox

        stepSize: doubleSpinBox.stepSize * factor
        value: doubleSpinBox.value * factor
        onValueChanged: doubleSpinBox.value = spinbox.value / factor
        to : doubleSpinBox.to * factor
        from : doubleSpinBox.from * factor

        validator: DoubleValidator {
            bottom: Math.min(spinbox.from, spinbox.to) * spinbox.factor
            top: Math.max(spinbox.from, spinbox.to) * spinbox.factor
        }

        textFromValue: function(value, locale) {
            return parseFloat(value * 1.0 / factor).toFixed(decimals)
        }
    }
}
