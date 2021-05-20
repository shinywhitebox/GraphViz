#!/bin/zsh

set -e
#
#  copy_graphviz_dylibs.sh, created on 18/05/21.
#  NOTE:
#  REQUIRES the use of zsh, as I use various zsh specific ... things
#  Ideas from : https://stackoverflow.com/questions/9602127/unable-to-use-dot-layout-graphviz-as-a-library
#  
. ./shared_vars.sh

HOMEBREW_FOLDER=/opt/homebrew
if [ "$ARCH" = "x86_64" ]; then
  echo "DO IT"
  HOMEBREW_FOLDER=/usr/local
fi

# Various source folders; where the originals are at
GV_INSTALL_FOLDER="${HOMEBREW_FOLDER}/Cellar/graphviz/2.47.1"
SRC_GZ_LIB_FOLDER="${GV_INSTALL_FOLDER}/lib"
SRC_OTHER_LIBS_FOLDER="${HOMEBREW_FOLDER}/opt"

EXPAT_INSTALL_FOLDER="${HOMEBREW_FOLDER}/Cellar/expat/2.3.0"
EXPAT_LIB_FOLDER="${EXPAT_INSTALL_FOLDER}/lib"

ZLIB_INSTALL_FOLDER="${HOMEBREW_FOLDER}/Cellar/zlib/1.2.11"
ZLIB_LIB_FOLDER="${ZLIB_INSTALL_FOLDER}/lib"

# Need to:
# 1) copy the required libs, to a shared folder
#   1.5) make sure the dependencies (otool -L) are also copied
# 2) make sure all libs reference @rpath/<libname> for LIB_ID_DYLIB.
#    install_name_tool -id @rpath/<libname> <path to lib here>
# 3) make sure dependent loads (otool -l <path to lib>) are correct.
#   install_name_tool -change <old path> @rpath/<libname>

declare -a GRAPHVIZ_LIBS=(
    "libcdt.5.dylib" 
    "libcgraph.6.dylib" 
    "libgvc.6.dylib"
    "libxdot.4.dylib"
    "libpathplan.4.dylib"
)
declare -a GRAPHVIZ_PLUGINS=(
    "graphviz/libgvplugin_core.6.dylib"
    "graphviz/libgvplugin_dot_layout.6.dylib"
    "graphviz/libgvplugin_quartz.6.dylib"
#    "graphviz/libgvplugin_gd.6.dylib"
#    "graphviz/libgvplugin_pango.6.dylib"
#    "graphviz/libgvplugin_rsvg.6.dylib"
#    "graphviz/libgvplugin_visio.6.dylib"
#    "graphviz/libgvplugin_webp.6.dylib"
)

declare -a OTHER_LIBS=(
    "libtool/lib/libltdl.7.dylib"
)

mkdir -p "${PROJECT_LIB_FOLDER}"

copy_lib_and_set_rpath() {
  LIB=$1
  SRC=$2
  DST=$3
  LIB_NAME="$LIB:t"
  echo "Copy lib ${LIB} from ${SRC} to ${DST}..."
  cp -f "${SRC}/${LIB}" "${DST}/${LIB_NAME}"
  install_name_tool -id @rpath/${LIB_NAME} "${DST}/${LIB_NAME}"
}

change_rpath() {
  DYLIB="$1"
  CHANGE="$2"
  LIB_NAME="$2:t"
#  echo "Look for '${CHANGE}' ..."
  install_name_tool -change "${CHANGE}" "@rpath/${LIB_NAME}" "${DYLIB}"
}

fix_lib_dependencies() {
    # Got through each element of known dependencies; and fix, adding other dependencies as we go
    for gv_lib in "${GRAPHVIZ_LIBS[@]}"; do
        copy_lib_and_set_rpath "${gv_lib}" "${SRC_GZ_LIB_FOLDER}" "${PROJECT_LIB_FOLDER}"
    done
    for other_lib in "${OTHER_LIBS[@]}"; do
        copy_lib_and_set_rpath "${other_lib}" "${SRC_OTHER_LIBS_FOLDER}" "${PROJECT_LIB_FOLDER}"
    done

    copy_lib_and_set_rpath "libexpat.1.dylib" "${EXPAT_LIB_FOLDER}" "${PROJECT_LIB_FOLDER}"
    copy_lib_and_set_rpath "libz.1.dylib" "${ZLIB_LIB_FOLDER}" "${PROJECT_LIB_FOLDER}"

    echo "Part2: Fixing rpaths..."
    change_rpath "${PROJECT_LIB_FOLDER}/libcgraph.6.dylib" "${SRC_GZ_LIB_FOLDER}/libcdt.5.dylib"

    change_rpath "${PROJECT_LIB_FOLDER}/libcdt.5.dylib" "${SRC_GZ_LIB_FOLDER}/libcdt.5.dylib"

    change_rpath "${PROJECT_LIB_FOLDER}/libgvc.6.dylib" "${SRC_OTHER_LIBS_FOLDER}/${OTHER_LIBS[1]}"
    for gv_lib in "${GRAPHVIZ_LIBS[@]}"; do
      change_rpath "${PROJECT_LIB_FOLDER}/libgvc.6.dylib" "${SRC_GZ_LIB_FOLDER}/${gv_lib}"
    done
    change_rpath "${PROJECT_LIB_FOLDER}/libgvc.6.dylib" "/usr/lib/libexpat.1.dylib"
    change_rpath "${PROJECT_LIB_FOLDER}/libgvc.6.dylib" "/usr/lib/libz.1.dylib"

    # Plugins
    for gv_plugin in "${GRAPHVIZ_PLUGINS[@]}"; do
        copy_lib_and_set_rpath "${gv_plugin}" "${SRC_GZ_LIB_FOLDER}" "${PROJECT_LIB_FOLDER}"
        PLUGIN_NAME="$gv_plugin:t"
        for gv_lib in "${GRAPHVIZ_LIBS[@]}"; do
          change_rpath "${PROJECT_LIB_FOLDER}/${PLUGIN_NAME}" "${SRC_GZ_LIB_FOLDER}/${gv_lib}"
        done
        change_rpath "${PROJECT_LIB_FOLDER}/${PLUGIN_NAME}" "/usr/lib/libexpat.1.dylib"
        change_rpath "${PROJECT_LIB_FOLDER}/${PLUGIN_NAME}" "/usr/lib/libz.1.dylib"
        change_rpath "${PROJECT_LIB_FOLDER}/${PLUGIN_NAME}" "${SRC_OTHER_LIBS_FOLDER}/${OTHER_LIBS[1]}"
    done
}

fix_lib_dependencies

echo "Done!"
