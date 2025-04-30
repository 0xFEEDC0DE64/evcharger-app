find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Quick WebSockets LinguistTools)

qt_standard_project_setup(REQUIRES 6.6 I18N_TRANSLATED_LANGUAGES de)

qt_add_executable(flotten-updater WIN32 MACOSX_BUNDLE
    addserialsrangedialog.h
    addserialsrangedialog.cpp
    addserialsrangedialog.ui
    deviceconnection.cpp
    deviceconnection.h
    devicesmodel.cpp
    devicesmodel.h
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

qt_add_resources(flotten-updater
    PREFIX /
    FILES
        goe-root-ca.pem
)

find_package(OpenSSL)
if (OpenSSL_Found)
    target_compile_definitions(flotten-updater HAS_OPENSSL)
    target_link_libraries(flotten-updater PUBLIC
        OpenSSL::SSL
        OpenSSL::Crypto
    )
endif()

target_link_libraries(flotten-updater PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Quick
    Qt6::WebSockets
    goecommon
)

install(TARGETS flotten-updater
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
