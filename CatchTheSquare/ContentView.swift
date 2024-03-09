//
//  ContentView.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack {
            Text("\(.init(systemName: "eye")) \(.init(systemName: "arrow.forward")) \(.init(systemName: "cursor.rays")) \(.init(systemName: "arrow.forward")) \( .init(systemName: "rectangle.inset.filled.and.cursorarrow"))")
                .font(.largeTitle)
            
            Toggle(immersiveSpaceIsShown ? "Exit" : "Play", isOn: $showImmersiveSpace)
                .font(.largeTitle)
                .toggleStyle(.button)
                .padding()
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "GameSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
