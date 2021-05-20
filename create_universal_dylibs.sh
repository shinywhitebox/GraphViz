#!/bin/zsh

set -e

. ./shared_vars.sh
. ./codesign_var.sh

mkdir -p "${UNIVERSAL_DEST}"

to_copy=("${(@f)$(ls ${PROJECT_LIB_FOLDER}/*.dylib)}")

codesign_copied_libs() {
  dylibs=( $(ls ${UNIVERSAL_DEST}/*.dylib) )
  for dylib in ${dylibs[@]}; do
    echo "Codesign: ${dylib}"
    codesign --force --deep --timestamp --sign ${CODESIGNING_ENTITY} ${dylib}
  done
}

for dylib in ${to_copy[@]}; do
  root_path=$dylib:h:h
  lib_name=$dylib:t
  echo "Make ${dylib} universal"

  x86_dylib="${root_path}/x86_64/${lib_name}"
  arm_dylib="${root_path}/arm64/${lib_name}"
  lipo "${x86_dylib}" "${arm_dylib}" -output "${UNIVERSAL_DEST}/${lib_name}" -create

done

codesign_copied_libs


