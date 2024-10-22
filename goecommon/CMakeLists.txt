find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Quick WebSockets LinguistTools)

qt_standard_project_setup(REQUIRES 6.6 I18N_TRANSLATED_LANGUAGES de)

qt_add_library(goecommon
    goesettings.cpp
    goesettings.h
)

target_link_libraries(goecommon
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
)

target_include_directories(goecommon PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
