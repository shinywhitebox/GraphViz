Pod::Spec.new do |spec|
  spec.name         = "GraphViz"
  spec.version      = "0.0.1"
  spec.authors      = "Neil Clayton"
  spec.summary      = "Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz to add a podspec"

  spec.description  = <<-DESC
  Copy of GraphViz https://github.com/SwiftDocOrg/GraphViz to add a podspec.  
  Includes dylibs for 11.0+ to make it all self contained.
                   DESC

  spec.homepage     = "http://shinywhitebox.com/"
  spec.license      = "MIT"
  spec.platform     = :osx, "11.00"
  spec.source       = { :git => "https://github.com/shinywhitebox/GraphViz.git", :tag => "#{spec.version}" }

  spec.frameworks = "Cocoa", "Foundation"

  spec.source_files  = "Sources/GraphViz/**/*.{h,swift,mm,m}", "GraphViz.h", "SWB/GraphViz/*"
  spec.module_map    = "graphviz.modulemap"
  
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # 'LIBRARY_SEARCH_PATHS' =>  '${SRCROOT}/Frameworks ' +
    #                            '$(SRCROOT)/../../Libraries/universal'
  }

  spec.vendored_libraries = 'Libraries/universal/*.dylib'
  spec.dependency "Clibgraphviz"

  spec.resources = ["Libraries/universal/*.dylib", "Libraries/graphviz/config6"]
  spec.libraries = "cdt.5", "cgraph.6", "gvc.6"

  spec.xcconfig = {'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'}
end




