cmake_minimum_required(VERSION 3.22)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME PandaControllerExample)
set(PROJECT_DESCRIPTION "PandaControllerExample")
set(PROJECT_URL "")

project(${PROJECT_NAME} CXX)

# Check if the project is built inside mc_rtc
if(NOT TARGET mc_rtc::mc_control)
  find_package(mc_rtc REQUIRED)
endif()

add_subdirectory(src)

set(AROBASE "@")
configure_file(etc/PandaControllerExample.in.yaml "${CMAKE_CURRENT_BINARY_DIR}/etc/PandaControllerExample.yaml")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/etc/PandaControllerExample.yaml" DESTINATION "${MC_CONTROLLER_RUNTIME_INSTALL_PREFIX}/etc")
install(FILES "etc/mc_rtc.yaml" DESTINATION "${MC_CONTROLLER_RUNTIME_INSTALL_PREFIX}/etc/${PROJECT_NAME}/")
