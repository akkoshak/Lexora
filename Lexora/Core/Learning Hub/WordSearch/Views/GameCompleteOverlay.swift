//
//  GameCompleteOverlay.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct GameCompleteOverlay: View {
    var onNewGame: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 64))
                
                Text("You found all words!")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                LexoraButton(title: "Play Again") {
                    onNewGame()
                }
                .padding(.horizontal, 32)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding(40)
        }
    }
}
