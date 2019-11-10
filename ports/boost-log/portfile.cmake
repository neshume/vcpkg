# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/log
    REF boost-1.71.0
    SHA512 ef3811c08e6fe9aa33ef46ca681b0b6e4c490bb99f7f0e53c100ca232ff29cf32db7c64928737347003578c91f5d3682547dc2305fbfe6d3771afd16e65b5e7e
    HEAD_REF master
)

file(READ "${SOURCE_PATH}/build/Jamfile.v2" _contents)
string(REPLACE "import ../../config/checks/config" "import config/checks/config" _contents "${_contents}")
string(REPLACE " <conditional>@select-arch-specific-sources" "#<conditional>@select-arch-specific-sources" _contents "${_contents}")
file(WRITE "${SOURCE_PATH}/build/Jamfile.v2" "${_contents}")
file(COPY "${CURRENT_INSTALLED_DIR}/share/boost-config/checks" DESTINATION "${SOURCE_PATH}/build/config")

file(READ ${SOURCE_PATH}/build/log-architecture.jam _contents)
string(REPLACE
    "\nproject.load [ path.join [ path.make $(here:D) ] ../../config/checks/architecture ] ;"
    "\nproject.load [ path.join [ path.make $(here:D) ] config/checks/architecture ] ;"
    _contents "${_contents}")
file(WRITE ${SOURCE_PATH}/build/log-architecture.jam "${_contents}")

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
