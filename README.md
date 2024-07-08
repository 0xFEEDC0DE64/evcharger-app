# evcharger-app

This app aims to be functional first and pretty second.

The app that is shipped with the products was made in opposite order and has a few problems now.

In contrast to the official go-e app this app has:
* Actual support to connect over cloud to the device
* Actual support to connect locally to the device
* No silly "device type does not match"
* No silly assumptions on what feature set the device has, it looks on the existance of api keys
* It shows the problems that the device is reporting like wifi error log, ocpp error log, cloud error log
* It shows any network communication problems like invalid websocket response received
* API Key Browser
* Support for all future go-e compatible products as it does not hardcode any device types (Therefore it also works with dereived products)
* If you enter the incorrect password it will tell you and lock up
* You can also select 06:00 in the scheduler
* You can also select any color you like in all color pickers

Lots of settings pages are still missing but this is a side project after work time and doesnt get much attention from Daniel's side.

I just need an app that just works when I stand in fron of my charger, I can't continue using solalaweb for all basic settings every day.

go-e Support is welcome to ship this app to customers that are facing WiFI, OCPP or any other issues.
