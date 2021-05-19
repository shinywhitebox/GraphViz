#!/bin/bash

COMMIT=1
OPTIONS=""

unset TEST
unset SPEC

usage() {
    echo "Usage: "
    echo "  -s Path to .podspec file. If want to push/test only one pod"
    echo "  -c to NOT commit all changes before building (which you prob don't want to do)"
    echo "  -n skip import validation (passes --skip-import-validation). C++ stuff."
    echo "  -t test (don't clean the generated workspace after linting)"
    echo "  -v pass --verbose flag to 'pod repo push'"
    exit 0
}

while getopts ":chntvs:" flag
do
case "$flag" in
    c) unset COMMIT;;
    t) TEST=1;;
    h) usage;;
    s) SPEC=${OPTARG};;
    n) OPTIONS="$OPTIONS --skip-import-validation";;
    v) OPTIONS="$OPTIONS --verbose";;
esac
done
shift $((OPTIND -1))

if [ "$SPEC" == "" ]; then
    # No specs specified? Get them all
    PODSPECS=$(ls *.podspec)
else
    # Use what is provided
    PODSPECS="${SPEC}"
fi

# Should clean all relevant specs here
for SPEC in ${PODSPECS[@]}; do
    # Get name of PodSpec file (without extension)
    SPEC_NAME=${SPEC%.*}
    echo "Cleaning cache for: ${SPEC_NAME}"
    pod cache clean --all $SPEC_NAME
done

# First; commit current work and push
if [ "${COMMIT}X" != "X" ]; then
    echo "Committing all work and pushing tag..."
    if ! git diff-index --quiet HEAD --; then
        echo "Comitting changes to git."
        git add -A
        git commit -m 'Working on framework, comitting spec for lint test/publication'
        $PWD/repushTag.sh    
        git push origin
    else
        echo "No changes in repo; not pushing"
    fi
fi

if [ "${TEST}X" != "X" ]; then
    echo "TESTING using 'pod spec lint', and leaving generated workspace in place"
    pod spec lint --allow-warnings --sources=gitaccess@git.shinywhitebox.com:repos/swb-specs,https://github.com/CocoaPods/Specs --no-clean $OPTIONS $SPEC
else
    pod repo push swb-specs --allow-warnings --sources=gitaccess@git.shinywhitebox.com:repos/swb-specs,https://github.com/CocoaPods/Specs $OPTIONS $SPEC
fi

