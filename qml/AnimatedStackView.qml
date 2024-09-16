import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

StackView {
    popEnter: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }
        ScaleAnimator {
            from: 2
            to: 1
            duration: 200
        }
    }
    popExit: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: 200
        }
        ScaleAnimator {
            from: 1
            to: 0.5
            duration: 200
        }
    }
    pushEnter: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }
        ScaleAnimator {
            from: 0.5
            to: 1
            duration: 200
        }
    }
    pushExit: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: 200
        }
        ScaleAnimator {
            from: 1
            to: 2
            duration: 200
        }
    }
}
