add_executable(flotten-updater
    chargerconnection.cpp
    chargerconnection.h
    chargersmodel.cpp
    chargersmodel.h
    flottenupdatersettings.cpp
    flottenupdatersettings.h
    importcertificatedialog.cpp
    importcertificatedialog.h
    importcertificatedialog.ui
    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui
    requestdialog.cpp
    requestdialog.h
    requestdialog.ui
    requestmodel.cpp
    requestmodel.h
    setarbitraryapikeydialog.cpp
    setarbitraryapikeydialog.h
    setarbitraryapikeydialog.ui
)

target_link_libraries(flotten-updater PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::WebSockets
    ssl
    crypto
    goecommon
)

qt_add_resources(flotten-updater
    PREFIX /
    FILES
        goe-root-ca.pem
)
