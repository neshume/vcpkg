if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Sciter is only available under a free license as DLLs.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "Sciter only supports Windows Desktop")
endif()

include(vcpkg_common_functions)

# header-only library
set(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)

set(SCITER_REVISION de53b62a3593ecf2c613b52c6aeb93fcbdefb01a)
set(SCITER_SHA fdc2e791e7da4acd622225d0142c7e6eb0153b0fc252110928d03c6aef3f7158eda0478509dac15c6cdeb281d72bd5e5360449cbd7867edc1c803dce37605e7c)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL x64)
    set(SCITER_ARCH 64)
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL x86)
    set(SCITER_ARCH 32)
endif()


# check out the `https://github.com/c-smile/sciter-sdk/archive/${SCITER_REVISION}.tar.gz`
# hash checksum can be obtained with `curl -L -o tmp.tgz ${URL} && vcpkg hash tmp.tgz`
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO c-smile/sciter-sdk
    REF ${SCITER_REVISION}
    SHA512 ${SCITER_SHA}
)

# disable stdafx.h
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001_patch_stdafx.patch
)

# install include directory
file(INSTALL ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/sciter
    FILES_MATCHING
    PATTERN "*.cpp"
    PATTERN "*.mm"
    PATTERN "*.h"
    PATTERN "*.hpp"
)

set(SCITER_SHARE ${CURRENT_PACKAGES_DIR}/share/sciter)
set(SCITER_TOOLS ${CURRENT_PACKAGES_DIR}/tools/sciter)
set(TOOL_PERMS FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# license
file(COPY ${SOURCE_PATH}/logfile.htm DESTINATION ${SCITER_SHARE})
file(COPY ${SOURCE_PATH}/license.htm DESTINATION ${SCITER_SHARE})
file(RENAME ${SCITER_SHARE}/license.htm ${SCITER_SHARE}/copyright)

# samples & widgets
file(COPY ${SOURCE_PATH}/samples DESTINATION ${SCITER_SHARE})
file(COPY ${SOURCE_PATH}/widgets DESTINATION ${SCITER_SHARE})

# tools
if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL Linux AND VCPKG_TARGET_ARCHITECTURE STREQUAL x64)
    set(SCITER_BIN ${SOURCE_PATH}/bin.gtk/x64)

    file(INSTALL ${SCITER_BIN}/packfolder DESTINATION ${SCITER_TOOLS} ${TOOL_PERMS})
    file(INSTALL ${SCITER_BIN}/usciter DESTINATION ${SCITER_TOOLS} ${TOOL_PERMS})
    file(INSTALL ${SCITER_BIN}/inspector DESTINATION ${SCITER_TOOLS} ${TOOL_PERMS})
    file(INSTALL ${SCITER_BIN}/libsciter-gtk.so DESTINATION ${SCITER_TOOLS})

    file(INSTALL ${SCITER_BIN}/libsciter-gtk.so DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(INSTALL ${SCITER_BIN}/libsciter-gtk.so DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(SCITER_BIN ${SOURCE_PATH}/bin.osx)

    file(INSTALL ${SCITER_BIN}/packfolder DESTINATION ${SCITER_TOOLS} ${TOOL_PERMS})
    file(INSTALL ${SCITER_BIN}/inspector.app DESTINATION ${SCITER_TOOLS})
    file(INSTALL ${SCITER_BIN}/sciter.app DESTINATION ${SCITER_TOOLS})
    file(INSTALL ${SCITER_BIN}/sciter-osx-64.dylib DESTINATION ${SCITER_TOOLS})

    file(INSTALL ${SCITER_BIN}/sciter-osx-64.dylib DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(INSTALL ${SCITER_BIN}/sciter-osx-64.dylib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

else()
    set(SCITER_BIN ${SOURCE_PATH}/bin/${SCITER_ARCH})

    file(INSTALL ${SOURCE_PATH}/bin/packfolder.exe DESTINATION ${SCITER_TOOLS})
    file(INSTALL ${SOURCE_PATH}/bin/tiscript.exe DESTINATION ${SCITER_TOOLS})

    file(INSTALL ${SCITER_BIN}/sciter.exe DESTINATION ${SCITER_TOOLS})
    file(INSTALL ${SCITER_BIN}/inspector.exe DESTINATION ${SCITER_TOOLS})
    file(INSTALL ${SCITER_BIN}/sciter.dll DESTINATION ${SCITER_TOOLS})

    file(INSTALL ${SCITER_BIN}/sciter.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(INSTALL ${SCITER_BIN}/sciter.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(INSTALL ${SCITER_BIN}/tiscript-sqlite.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(INSTALL ${SCITER_BIN}/tiscript-sqlite.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

message(STATUS "Warning: Sciter requires manual deployment of the correct DLL files.")
