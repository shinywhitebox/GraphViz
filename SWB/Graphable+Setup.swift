import Foundation

extension Graph {
    public static func setupBuiltInGraphviz() {
        let ourBundle = Bundle(for: Renderer.self)
        let url = ourBundle.bundleURL.appendingPathComponent("Versions/A/Resources", isDirectory: true)
        let absoluteString = url.path
        let unsafeCString = absoluteString.cString(using: .utf8)
        setenv("GVBINDIR", unsafeCString, 1)
    }
}


