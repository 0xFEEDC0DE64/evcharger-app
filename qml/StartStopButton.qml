import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import EVChargerApp

Button {
    id: button

    required property DeviceConnection deviceConnection

    ApiKeyValueHelper {
        id: alwApiKeyHelper
        deviceConnection: button.deviceConnection
        apiKey: "alw"
    }

    ApiKeyValueHelper {
        id: modelStatusApiKeyHelper
        deviceConnection: button.deviceConnection
        apiKey: "modelStatus"
    }

    SetValueHelper {
        id: setValueHelper
        deviceConnection: button.deviceConnection
        apiKey: ""
    }

    BusyIndicator {
        visible: setValueHelper.pending
    }

    RequestStatusText {
        request: setValueHelper
    }

    Material.accent: Material.White

    text: alwApiKeyHelper.value ? qsTr("Stop") : qsTr("Start")

    readonly property int notChargingBecauseAccessControl: Constants.ModelStatus.NotChargingBecauseAccessControl
    readonly property int forceOff: Constants.ForceState.Off
    readonly property int forceOn: Constants.ForceState.On

    onClicked: {
        // random delays not considered at all in this logic (yet)

        if (alwApiKeyHelper.value) {
            // currently allowed to charge -> STOP

            setValueHelper.apiKey = "frc"
            setValueHelper.setValue(forceOff)
        } else {
            // currently not allowed to -> START

            if (modelStatusApiKeyHelper.value === notChargingBecauseAccessControl) {
                // not charging because of access control -> start transaction
                setValueHelper.apiKey = "trx"
                setValueHelper.setValue(0)
            } else {
                // set force state to on
                setValueHelper.apiKey = "frc"
                setValueHelper.setValue(forceOn)
            }
        }
    }
}
