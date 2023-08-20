cmake_minimum_required(VERSION 3.16)

project(RoundedWindow VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Core Gui Widgets)

qt_standard_project_setup()

qt_add_executable(RoundedWindow
    MACOSX_BUNDLE
    main.cpp

    "cpp/windowshape.h"
    "cpp/windowshape.cpp"
    "cpp/screenhandler.h"
    "cpp/screenhandler.cpp"

    # ICON
    icon.rc

)

qt_add_qml_module(RoundedWindow
    URI RoundedWindow
    VERSION 1.0

    QML_FILES
    Main.qml

    #qml

    "qml/CreateMainWindow.qml"
    "qml/WindowHandler.qml"
    "qml/ResizeHandler.qml"
    "qml/Window.qml"
    "qml/OptionsMenu.qml"
    "qml/SnapHandler.qml"
    "qml/SnapBar.qml"
    "qml/Rect.qml"
    "qml/SnapLayers.qml"
    "qml/SnapTopLayers.qml"


    #js

    "js/Alpha.js"

    RESOURCES
    res.qrc


)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(RoundedWindow PROPERTIES
    #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.RoundedWindow
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(RoundedWindow
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS RoundedWindow
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
