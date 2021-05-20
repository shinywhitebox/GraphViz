Pod::Spec.new do |spec|
  spec.name         = "Clibgraphviz"
  spec.version      = "0.0.1"
  spec.authors      = "Neil Clayton"
  spec.summary      = "Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz to add a podspec"

  spec.description  = <<-DESC
  Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz 
  This is here to shut up the "import Clibgraphviz". 
  Actual headers are included (privately) in the GraphViz framework.
                   DESC

  spec.homepage     = "http://shinywhitebox.com/"
  spec.license      = "MIT"
  spec.platform     = :osx, "10.15"
  spec.source       = { :git => "https://github.com/shinywhitebox/GraphViz.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/Clibgraphviz/**/*.h", "SWB/Clibgraphviz/*"
  # spec.private_header_files = "Sources/Clibgraphviz/*.h"

  spec.frameworks = "Cocoa", "Foundation"

  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

  # spec.library = 'c++'
  # spec.xcconfig = {
  #   'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
  #   'CLANG_CXX_LIBRARY' => 'libc++'
  # }

  spec.xcconfig = {'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'}
end




