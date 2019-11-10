# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building will not support load data through plugins.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO openscenegraph/OpenSceneGraph
	REF OpenSceneGraph-3.4.1
	SHA512  4a65625e208d24256b5564bbe9d6f557758b51fae0acf85d1f71968a237fec299088536830fc862d25e02039de9ea13176b298a68aaa644eac958acbe1f4e143
	HEAD_REF master
    #PATCHES
    #    "${CMAKE_CURRENT_LIST_DIR}/collada.patch"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    # PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS
        -DOSG_USE_UTF8_FILENAME=ON
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# handle osg tools and plugins 
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

set(OSG_TOOL_PATH ${CURRENT_PACKAGES_DIR}/tools/osg)
file(MAKE_DIRECTORY ${OSG_TOOL_PATH})

file(GLOB OSG_TOOLS ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(COPY ${OSG_TOOLS} DESTINATION ${OSG_TOOL_PATH})
file(REMOVE_RECURSE ${OSG_TOOLS})
file(GLOB OSG_TOOLS_DBG ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(REMOVE_RECURSE ${OSG_TOOLS_DBG})

file(GLOB OSG_PLUGINS_DBG ${CURRENT_PACKAGES_DIR}/debug/bin/osgPlugins-3.4.1/*.dll)
file(COPY ${OSG_PLUGINS_DBG} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/tools/osg/osgPlugins-3.4.1)
file(GLOB OSG_PLUGINS_REL ${CURRENT_PACKAGES_DIR}/bin/osgPlugins-3.4.1/*.dll)
file(COPY ${OSG_PLUGINS_REL} DESTINATION ${OSG_TOOL_PATH}/osgPlugins-3.4.1)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin/osgPlugins-3.4.1/)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin/osgPlugins-3.4.1/)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/osg)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/osg/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/osg/copyright)
