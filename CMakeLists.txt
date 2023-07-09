cmake_minimum_required(VERSION 3.26)
if(!WIN32)
  message(FATAL_ERROR "This is a Windows only project")
endif()
set(LUAJIT_VERSION 2.1.0.3)
project(LuaJIT
  VERSION ${LUAJIT_VERSION}
  DESCRIPTION "LuaJIT and LuaRocks packaged by DEVCOM"
  HOMEPAGE_URL https://github.com/DevelopersCommunity/cmake-luajit
  LANGUAGES C
  )

set (LUAJIT_SRC ${CMAKE_CURRENT_LIST_DIR}/LuaJIT/src)
set (LUAJIT_JIT ${CMAKE_CURRENT_LIST_DIR}/LuaJIT/src/jit)

find_program(MSVC cl)
if(MSVC STREQUAL "MSVC-NOTFOUND")
  message(FATAL_ERROR "MSVC compiler not found")
endif()
set(LUAROCKS_VERSION 3.9.2)
set(LUAROCKS_TARBALL luarocks-${LUAROCKS_VERSION}-windows-64.zip)

if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/${LUAROCKS_TARBALL})
  file(DOWNLOAD http://luarocks.github.io/luarocks/releases/${LUAROCKS_TARBALL}
    ${CMAKE_CURRENT_LIST_DIR}/${LUAROCKS_TARBALL}
    )
  file(ARCHIVE_EXTRACT INPUT ${CMAKE_CURRENT_LIST_DIR}/${LUAROCKS_TARBALL}
    DESTINATION ${CMAKE_CURRENT_LIST_DIR}
    )
endif()

add_custom_command(OUTPUT ${LUAJIT_SRC}/luajit.exe ${LUAJIT_SRC}/lua51.dll ${LUAJIT_SRC}/lua51.lib
  COMMAND msvcbuild.bat
  WORKING_DIRECTORY ${LUAJIT_SRC}
  COMMENT "Compiling LuaJIT"
  )
add_custom_target(luajit ALL DEPENDS ${LUAJIT_SRC}/luajit.exe)
add_custom_target(luadll ALL DEPENDS ${LUAJIT_SRC}/lua51.dll)
add_custom_target(lualib ALL DEPENDS ${LUAJIT_SRC}/lua51.lib)

install(PROGRAMS
  ${LUAJIT_SRC}/luajit.exe
  ${LUAJIT_SRC}/lua51.dll
  ${CMAKE_CURRENT_LIST_DIR}/luarocks-${LUAROCKS_VERSION}-windows-64/luarocks.exe
  ${CMAKE_CURRENT_LIST_DIR}/luarocks-${LUAROCKS_VERSION}-windows-64/luarocks-admin.exe
  TYPE BIN)
install(FILES ${LUAJIT_SRC}/lua51.lib
  TYPE LIB)
install(FILES ${LUAJIT_SRC}/lauxlib.h  ${LUAJIT_SRC}/lua.h  ${LUAJIT_SRC}/lua.hpp  ${LUAJIT_SRC}/luaconf.h  ${LUAJIT_SRC}/lualib.h
  TYPE INCLUDE)

install(DIRECTORY ${LUAJIT_JIT} DESTINATION bin/lua
  FILES_MATCHING PATTERN *.lua)
install(FILES ${CMAKE_CURRENT_LIST_DIR}/config.lua
  DESTINATION etc/luarocks)
install(FILES ${LUAJIT_SRC}/../COPYRIGHT TYPE DOC)

set(CPACK_GENERATOR ZIP WIX)
set(CPACK_WIX_UPGRADE_GUID "6a62e303-6669-4f48-bce3-36052132be3b")
list(APPEND CPACK_WIX_EXTENSIONS WixUtilExtension)
list(APPEND CPACK_WIX_PATCH_FILE ${CMAKE_CURRENT_LIST_DIR}/WixPatch.xml)
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_LIST_DIR}/LICENSE.txt)
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR DEVCOM)
include(CPack)
