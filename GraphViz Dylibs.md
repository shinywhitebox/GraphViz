# Howto

1. Install graphviz:

    brew install graphviz
   
2. Run the script (on both Intel + arm) to copy the installed .dylibs that we need, and replace @rpath

    copy_graphviz_dylibs.sh
   
3. Run the script to make a Universal + sign said univeral

    create_universal_dylibs.sh
   
# Running

## Linking
The project is setup to link/include those libraries from the ${PROJECT_DIR}/Libraries/universal/ folder.
That seems to make xcode happy; from a linking perspective.


## Packaging
The dylibs need to be copied into the frameworks Versions/A/Libraries folder.
This is done by:

    copy_dylibs_to_framework.sh

which is executed as part of the xcode build steps; for the SWBAudio2 framework itself.

## Runtime

You MUST call GraphableHelpers.setupBuiltInGraphviz() before running any DOT visualization.
This is needed to setup the paths to the dylibs; such that graphviz iwll load them from the SWBAudio2.framework.

