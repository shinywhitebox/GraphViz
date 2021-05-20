//
//  SimpleExampleApp.swift
//  SimpleExample
//
//  Created by Neil Clayton on 19/05/21.
//

import SwiftUI
import GraphViz

@main
struct SimpleExampleApp: App {
    init() {
        Graph.setupBuiltInGraphviz()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
