add_library(goecommon
    goesettings.cpp
    goesettings.h
)

target_link_libraries(goecommon
    Qt6::Core
)

target_include_directories(goecommon PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
