//
//  ScoreView.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/9/24.
//

import SwiftUI


struct ScoreView: View {
    let game: Game
    let score: Score
    @Environment(\.presentationMode) var presentationMode
    
    init(game: Game) {
        self.score = game.score
        self.game = game
    }
    
    var body: some View {
        VStack {
            // add grid image of final where completed is green
            
            Text("Final Score")
            Text("Hit: \(score.hit)")
            Text("Wrong: \(score.wrong)")
            Text("Missed: \(score.missed)")
            Text("Total: \(score.hit - (score.wrong + score.missed/2))")
                .font(.title)
            
            Button("Main Menu") {
                presentationMode.wrappedValue.dismiss()
                game.reset()
            }
        }
        .padding()
    }
}

#Preview {
    ScoreView(game: Game())
}
