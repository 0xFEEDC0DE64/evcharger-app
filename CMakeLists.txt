cmake_minimum_required(VERSION 3.16)
project(evcharger-app LANGUAGES CXX)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
#add_compile_options(-std=c++2b)

find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

add_definitions(-DQT_GUI_LIB)
add_subdirectory(3rdparty)

add_subdirectory(evcharger-app)
add_subdirectory(goecommon)
