include(vcpkg_common_functions)

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building will not support load data through plugins.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(VCPKG_CRT_LINKAGE STREQUAL static)
    message(FATAL_ERROR "osgearth does not support static CRT linkage")
endif()

file(GLOB OSG_PLUGINS_SUBDIR ${CURRENT_INSTALLED_DIR}/tools/osg/osgPlugins-*)
list(LENGTH OSG_PLUGINS_SUBDIR OSG_PLUGINS_SUBDIR_LENGTH)
if(NOT OSG_PLUGINS_SUBDIR_LENGTH EQUAL 1)
    message(FATAL_ERROR "Could not determine osg version")
endif()
string(REPLACE "${CURRENT_INSTALLED_DIR}/tools/osg/" "" OSG_PLUGINS_SUBDIR "${OSG_PLUGINS_SUBDIR}")

#vcpkg_download_distfile(
#    VS2017PATCH
#    URLS "https://github.com/remoe/osgearth/commit/f7081cc4f9991c955c6a0ef7b7b50e48360d14fd.diff"
#    FILENAME "osgearth-f7081cc4f9991c955c6a0ef7b7b50e48360d14fd.patch"
#    SHA512 eadb47a5713c00c05add8627e5cad22844db041da34081d59104151a1a1e2d5ac9552909d67171bfc0449a3e4d2930dd3a7914d3ec7ef7ff1015574e9c9a6105
#)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gwaldron/osgearth
    REF osgearth-2.8
    SHA512   d33eb41c3076ae4c0c7f30d7cf278bcb60b6e704cd368084d7dbd996744961520980b1e0b5b5e6fa6a5cd2e7b9583be0acd81fc3cb0959f16bd20751b801fc31 
    HEAD_REF master
    #PATCHES ${VS2017PATCH}
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

#Release
set(OSGEARTH_TOOL_PATH ${CURRENT_PACKAGES_DIR}/tools/osgearth)
set(OSGEARTH_TOOL_PLUGIN_PATH ${OSGEARTH_TOOL_PATH}/${OSG_PLUGINS_SUBDIR})

file(MAKE_DIRECTORY ${OSGEARTH_TOOL_PATH})
file(MAKE_DIRECTORY ${OSGEARTH_TOOL_PLUGIN_PATH})

file(GLOB OSGEARTH_TOOLS ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(GLOB OSGDB_PLUGINS ${CURRENT_PACKAGES_DIR}/bin/osgdb*.dll)

file(COPY ${OSGEARTH_TOOLS} DESTINATION ${OSGEARTH_TOOL_PATH})
file(COPY ${OSGDB_PLUGINS} DESTINATION ${OSGEARTH_TOOL_PLUGIN_PATH})

file(REMOVE_RECURSE ${OSGEARTH_TOOLS})
file(REMOVE_RECURSE ${OSGDB_PLUGINS})

#Debug
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

set(OSGEARTH_DEBUG_TOOL_PATH ${CURRENT_PACKAGES_DIR}/debug/tools/osgearth)
set(OSGEARTH_DEBUG_TOOL_PLUGIN_PATH ${OSGEARTH_DEBUG_TOOL_PATH}/${OSG_PLUGINS_SUBDIR})

file(MAKE_DIRECTORY ${OSGEARTH_DEBUG_TOOL_PATH})
file(MAKE_DIRECTORY ${OSGEARTH_DEBUG_TOOL_PLUGIN_PATH})

file(GLOB OSGEARTH_DEBUG_TOOLS ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(GLOB OSGDB_DEBUG_PLUGINS ${CURRENT_PACKAGES_DIR}/debug/bin/osgdb*.dll)

file(COPY ${OSGEARTH_DEBUG_TOOLS} DESTINATION ${OSGEARTH_DEBUG_TOOL_PATH})
file(COPY ${OSGDB_DEBUG_PLUGINS} DESTINATION ${OSGEARTH_DEBUG_TOOL_PLUGIN_PATH})

file(REMOVE_RECURSE ${OSGEARTH_DEBUG_TOOLS})
file(REMOVE_RECURSE ${OSGDB_DEBUG_PLUGINS})


# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/osgearth)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/osgearth/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/osgearth/copyright)
