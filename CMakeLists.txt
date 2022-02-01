cmake_minimum_required(VERSION 3.10)

project(qml-lliurex-ui)

find_package(ECM 1.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(KDEInstallDirs)
include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)

add_subdirectory(noise)

install (DIRECTORY ui DESTINATION ${KDE_INSTALL_QMLDIR}/net/lliurex)
