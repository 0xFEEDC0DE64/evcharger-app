import EVChargerApp

SendMessageHelper {
    required property string apiKey

    function setValue(value) {
        sendMessage({
            type: "setValue",
            key: apiKey,
            value: value
        })
    }
}
