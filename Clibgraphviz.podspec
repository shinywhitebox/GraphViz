Pod::Spec.new do |spec|
  spec.name         = "Clibgraphviz"
  spec.version      = "1.0.0"
  spec.authors      = "Neil Clayton"
  spec.summary      = "Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz to add a podspec"

  spec.description  = <<-DESC
  Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz 
  This is here to shut up the "import Clibgraphviz". It includes the .h files for graphviz.

  Had to comment out the <inttpyes> include to make xcode (12) happy. Seemed to work ok.

                   DESC

  spec.homepage     = "http://shinywhitebox.com/"
  spec.license      = "MIT"
  spec.platform     = :osx, "10.15"
  spec.source       = { :git => "https://github.com/shinywhitebox/GraphViz.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/Clibgraphviz/*.h", "SWB/Clibgraphviz/*"
  spec.frameworks = "Cocoa", "Foundation"

  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

  spec.xcconfig = {'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'}
end




