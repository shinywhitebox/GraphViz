#!/bin/zsh

set -e

. ./shared_vars.sh

CSFP=$(xcodebuild -target GraphViz -configuration Debug -showBuildSettings | sed -n "s/.*CODESIGNING_FOLDER_PATH = \(.*\)/\1/p")

CFP=${CODESIGNING_FOLDER_PATH:-${CSFP}}
echo "CFP: ${CFP}"

echo "UPDATE THIS TO WORK AT A RESOURCE FOLDER"
exit 4
DEST_FOLDER="${CFP}/Resources/Libraries/"

mkdir -p "${DEST_FOLDER}"

to_copy=("${(@f)$(ls ${UNIVERSAL_DEST}/*.dylib)}")
for dylib in ${to_copy[@]}; do
  echo "Copy ${dylib}"
  cp -f ${dylib} ${DEST_FOLDER}
done

cp -f ${PROJECT_LIB_FOLDER}/../config6 ${DEST_FOLDER}/


