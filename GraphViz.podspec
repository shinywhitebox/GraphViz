Pod::Spec.new do |spec|
  spec.name         = "GraphViz"
  spec.version      = "0.0.3"
  spec.authors      = "Neil Clayton"
  spec.summary      = "Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz to add a podspec"

  spec.description  = <<-DESC
  Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz to add a podspec
                   DESC

  spec.homepage     = "http://shinywhitebox.com/"
  spec.license      = "MIT"
  spec.platform     = :osx, "10.15"
  spec.source       = { :git => "https://github.com/shinywhitebox/GraphViz.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/GraphViz/**/*.{h,swift,mm,m}"
  # spec.private_header_files = "SWBShared2/**/*_Private.h"
  spec.swift_version = "5.2.4"
  # spec.exclude_files = "SWBShared2/Exclude"
  # spec.public_header_files = "SWBShared2/**/*.h"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.resources = "Things/Assets/**/*.xcassets"
  #spec.resource_bundles = {'SharedMedia' => "Assets/SharedMedia.xcassets"}

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  spec.frameworks = "Cocoa", "Foundation"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.xcconfig = {'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'}
end




