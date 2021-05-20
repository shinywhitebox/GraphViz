//
//  ContentView.swift
//  SimpleExample
//
//  Created by Neil Clayton on 19/05/21.
//

import SwiftUI
import GraphViz

struct ContentView: View {
    @State var pngData: Data? = nil
    private var graph : Graph
    private var updateQueue = DispatchQueue(label: "com.swb.graph.update")
    
    init() {
        self.graph = Graph()
        let a = Node("A")
        let b = Node("B")
        graph.append(a)
        graph.append(b)
        graph.append(Edge(from: a, to: b))
    }
    
    @ViewBuilder
    var body: some View {
        Group {
            if pngData != nil {
                Image(nsImage: NSImage(data: pngData!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.white))
            } else {
                Text("GRAPH FAILED!")
            }
            Text("Hello, world!")
                .padding()
        }
        .fixedSize()
        .onAppear {
            updateImage()
        }
    }
    
    func updateImage() {
        updateQueue.async {
            // initial view
            graph.render(using: .dot, to: .png) { result in
                if case .success(let data) = result {
                    DispatchQueue.main.async {
                        pngData = data
                    }
                } else if case .failure(let err) = result {
                    print("Failed to graph: \(err)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
