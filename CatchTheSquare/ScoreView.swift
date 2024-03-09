//
//  ScoreView.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/9/24.
//

import SwiftUI


struct ScoreView: View {
    var score: Score
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Final Score")
            Text("Hit: \(score.hit)")
            Text("Wrong: \(score.wrong)")
            Text("Missed: \(score.missed)")
            
            Button("Main Menu") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    ScoreView(score: Score())
}
