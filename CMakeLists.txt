cmake_minimum_required(VERSION 3.10)

project(qml-lliurex-ui)

add_subdirectory(noise)

find_package(Qt6 "6.7.0" REQUIRED COMPONENTS Qml Quick)

install (DIRECTORY ui DESTINATION ${QT6_INSTALL_QML}/net/lliurex)
install (DIRECTORY media DESTINATION "share/qml-module-lliurex-ui/")
