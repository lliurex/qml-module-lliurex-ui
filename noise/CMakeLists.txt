

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 REQUIRED COMPONENTS Qml Quick)

#set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -fexceptions")

add_library(lliurexuinoiseplugin SHARED plugin.cpp noise.cpp)

target_link_libraries (lliurexuinoiseplugin
    Qt5::Qml
    Qt5::Quick
)

install (TARGETS lliurexuinoiseplugin DESTINATION ${KDE_INSTALL_QMLDIR}/net/lliurex/ui/noise)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/net/lliurex/ui/noise)
