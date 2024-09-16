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

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Quick WebSockets LinguistTools)

qt_standard_project_setup(REQUIRES 6.6 I18N_TRANSLATED_LANGUAGES de)

qt_add_executable(evcharger-app WIN32 MACOSX_BUNDLE
    src/apikeyvaluehelper.cpp
    src/apikeyvaluehelper.h
    src/appsettings.cpp
    src/appsettings.h
    src/deviceconnection.cpp
    src/deviceconnection.h
    src/devicesmodel.cpp
    src/devicesmodel.h
    src/main.cpp
    src/sendmessagehelper.cpp
    src/sendmessagehelper.h
)

target_include_directories(evcharger-app
    PRIVATE
        src
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
        qml/AboutPage.qml
        qml/AccessPage.qml
        qml/AddDeviceScreen.qml
        qml/AnimatedStackLayout.qml
        qml/AnimatedStackView.qml
        qml/ApiKeyValueItem.qml
        qml/ApiSettingsPage.qml
        qml/AppInstance.qml
        qml/AppSettingsPage.qml
        qml/BaseNavigationPage.qml
        qml/CablePage.qml
        qml/CarPage.qml
        qml/CellularPage.qml
        qml/CenteredDialog.qml
        qml/ChargerTabPage.qml
        qml/ChargingConfigurationPage.qml
        qml/ChargingSpeedPage.qml
        qml/CloudPage.qml
        qml/CloudUrlsModel.qml
        qml/ConfirmingOnOffSwitch.qml
        qml/ConnectingScreen.qml
        qml/ConnectionPage.qml
        qml/Constants.qml
        qml/ControllerPage.qml
        qml/ControllerTabPage.qml
        qml/CurrentLevelsPage.qml
        qml/DailyTripPage.qml
        qml/DateAndTimePage.qml
        qml/DeviceHeaderBar.qml
        qml/DeviceListScreen.qml
        qml/DeviceScreen.qml
        qml/DisplaySettingsPage.qml
        qml/DoubleSpinBox.qml
        qml/EcoTabPage.qml
        qml/EditValueItem.qml
        qml/EthernetPage.qml
        qml/EVChargerApp.qml
        qml/FirmwarePage.qml
        qml/FlexibleEnergyTariffPage.qml
        qml/GeneralOnOffSwitch.qml
        qml/GeneralPage.qml
        qml/GridPage.qml
        qml/GroundCheckPage.qml
        qml/HardwareInformationPage.qml
        qml/HotspotPage.qml
        qml/InformationsTabPage.qml
        qml/KwhLimitPage.qml
        qml/LedPage.qml
        qml/LicensesPage.qml
        qml/LoadBalancingPage.qml
        qml/LogicModeButton.qml
        qml/MainScreen.qml
        qml/MqttPage.qml
        qml/NamePage.qml
        qml/NavigationItem.qml
        qml/NavigationPage.qml
        qml/NotificationsPage.qml
        qml/OcppPage.qml
        qml/OpenLinkButton.qml
        qml/PasswordPage.qml
        qml/PvSurplusPage.qml
        qml/RebootPage.qml
        qml/RequestStatusText.qml
        qml/SchedulerDayPage.qml
        qml/SchedulerPage.qml
        qml/ScrollableTabPage.qml
        qml/SecurityPage.qml
        qml/SelectLogicModeItem.qml
        qml/SelectPhaseSwitchModeItem.qml
        qml/SensorsConfigurationPage.qml
        qml/SetPriceLimitPage.qml
        qml/SettingsTabPage.qml
        qml/SetValueHelper.qml
        qml/SimpleNavigationItem.qml
        qml/StartStopButton.qml
        qml/SwitchLanguagePage.qml
        qml/TimeComponentLabel.qml
        qml/TimePickerDialog.qml
        qml/TimePickerLabel.qml
        qml/TimePicker.qml
        qml/TitleText.qml
        qml/VerticalTabButton.qml
        qml/WhiteBox.qml
        qml/WhiteCheckDelegate.qml
        qml/WhiteItemDelegate.qml
        qml/WhiteSwipeDelegate.qml
        qml/WiFiErrorsPage.qml
        qml/WiFiPage.qml
        qml/WiFiScanPage.qml
    RESOURCES
        qml/icons/Charger.svg
        qml/icons/ChargerV3.svg
        qml/icons/ChargerV4.svg
        qml/icons/Controller.svg
        qml/icons/Alarm.svg
        qml/icons/EcoModeFilled.svg
        qml/icons/Charts.svg
        qml/images/controller.png
        qml/images/geminiFlex.png
        qml/images/homeFix.png
        qml/images/homePlus.png
        qml/images/wattpilot.png
        qml/images/phoenix.png
        qml/images/geminiFix.png
        qml/material-icons/add.svg
        qml/material-icons/grid_guides.svg
        qml/material-icons/open_in_new.svg
        qml/material-icons/settings.svg
        qml/ui-icons/MaterialIcons-Regular.ttf
)

set_source_files_properties(Constants.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

target_link_libraries(evcharger-app PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
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
