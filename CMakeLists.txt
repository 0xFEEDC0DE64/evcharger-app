cmake_minimum_required(VERSION 3.16)
project(evcharger-app LANGUAGES CXX)
set(CMAKE_AUTOMOC ON)
#set(CMAKE_CXX_STANDARD 23)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_CXX_EXTENSIONS ON)
add_compile_options(-std=c++2b)

find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

add_definitions(-DQT_GUI_LIB)
add_subdirectory(3rdparty)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick WebSockets LinguistTools)

qt_standard_project_setup(REQUIRES 6.6 I18N_TRANSLATED_LANGUAGES de)

qt_add_executable(evcharger-app WIN32 MACOSX_BUNDLE
    apikeyvaluehelper.cpp
    apikeyvaluehelper.h
    appsettings.cpp
    appsettings.h
    deviceconnection.cpp
    deviceconnection.h
    devicesmodel.cpp
    devicesmodel.h
    main.cpp
    sendmessagehelper.cpp
    sendmessagehelper.h
)

qt6_add_translations(evcharger-app
    RESOURCE_PREFIX /EVChargerApp/i18n
    TS_FILE_BASE qml
    TS_FILE_DIR i18n
)

set_property(TARGET evcharger-app APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android)

if (ANDROID)
    include(${ANDROID_SDK_ROOT}/android_openssl/CMakeLists.txt)
    set_target_properties(evcharger-app PROPERTIES QT_ANDROID_EXTRA_LIBS "${ANDROID_EXTRA_LIBS}")
endif()

qt_add_qml_module(evcharger-app
    URI EVChargerApp
    VERSION 1.0
    QML_FILES
        AboutPage.qml
        AccessPage.qml
        AddDeviceScreen.qml
        AnimatedStackLayout.qml
        AnimatedStackView.qml
        ApiKeyValueItem.qml
        ApiSettingsPage.qml
        AppInstance.qml
        AppSettingsPage.qml
        BaseNavigationPage.qml
        CablePage.qml
        CarPage.qml
        CenteredDialog.qml
        ChangeNumberItem.qml
        ChargerTabPage.qml
        ChargingConfigurationPage.qml
        ChargingSpeedPage.qml
        CloudPage.qml
        CloudUrlsModel.qml
        ConnectingScreen.qml
        ConnectionPage.qml
        ControllerPage.qml
        ControllerTabPage.qml
        CurrentLevelsPage.qml
        DailyTripPage.qml
        DateAndTimePage.qml
        DeviceListScreen.qml
        DeviceScreen.qml
        DisplaySettingsPage.qml
        EcoTabPage.qml
        EthernetPage.qml
        EVChargerApp.qml
        FirmwarePage.qml
        FlexibleEnergyTariffPage.qml
        GeneralOnOffSwitch.qml
        GeneralPage.qml
        GridPage.qml
        GroundCheckPage.qml
        HardwareInformationPage.qml
        HotspotPage.qml
        InformationsTabPage.qml
        KwhLimitPage.qml
        LedPage.qml
        LicensesPage.qml
        LoadBalancingPage.qml
        LogicModeButton.qml
        MainScreen.qml
        MqttPage.qml
        NamePage.qml
        NavigationItem.qml
        NavigationPage.qml
        NotificationsPage.qml
        OcppPage.qml
        PasswordPage.qml
        PvSurplusPage.qml
        RebootPage.qml
        RequestStatusText.qml
        SchedulerDayPage.qml
        SchedulerPage.qml
        SecurityPage.qml
        SelectLogicModeItem.qml
        SensorsConfigurationPage.qml
        SetPriceLimitPage.qml
        SettingsTabPage.qml
        SimpleNavigationItem.qml
        SwitchLanguagePage.qml
        TimeComponentLabel.qml
        TimePickerDialog.qml
        TimePickerLabel.qml
        TimePicker.qml
        VerticalTabButton.qml
        WhiteBox.qml
        WhiteCheckDelegate.qml
        WhiteItemDelegate.qml
        WhiteSwipeDelegate.qml
        WiFiErrorsPage.qml
        WiFiOnOffSwitch.qml
        WiFiPage.qml
        WiFiScanPage.qml
    RESOURCES
        icons/Charger.svg
        icons/ChargerV3.svg
        icons/ChargerV4.svg
        icons/Controller.svg
        icons/Alarm.svg
        icons/EcoModeFilled.svg
        icons/Charts.svg
        images/controller.png
        images/geminiFlex.png
        images/homeFix.png
        images/homePlus.png
        images/wattpilot.png
        images/phoenix.png
        images/geminiFix.png
        material-icons/add.svg
        material-icons/grid_guides.svg
        material-icons/settings.svg
        ui-icons/MaterialIcons-Regular.ttf
)

target_link_libraries(evcharger-app PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::WebSockets
    qmsgpack
    QtZeroConf
)

install(TARGETS evcharger-app
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET evcharger-app
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
