import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EVChargerApp

Text {
    required property SendMessageHelper request

    wrapMode: Text.Wrap

    visible: !request.pending && request.response != undefined

    text: {
        if (request.response == undefined)
            return ""
        if (request.response.type == "response") {
            if (request.response.success)
                return "OK"
            if ('message' in request.response)
                return request.response.message
        }
        return JSON.stringify(request.response)
    }
}
