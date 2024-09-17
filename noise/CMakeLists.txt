
find_package(Qt6 "6.7.0" REQUIRED COMPONENTS Qml Quick)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -fexceptions")

add_library(lliurexuinoiseplugin SHARED plugin.cpp noise.cpp texture.cpp)

target_link_libraries (lliurexuinoiseplugin
    Qt6::Qml
    Qt6::Quick
)

install (TARGETS lliurexuinoiseplugin DESTINATION ${QT6_INSTALL_QML}/net/lliurex/ui/noise)
install(FILES qmldir DESTINATION ${QT6_INSTALL_QML}/net/lliurex/ui/noise)
