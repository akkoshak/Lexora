//
//  SessionCompleteOverlay.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct SessionCompleteOverlay: View {
    let correct: Int
    let incorrect: Int
    let total: Int
    var onRestart: () -> Void
 
    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
 
            VStack(spacing: 24) {
                Text(correct == total ? "🏆" : correct >= total / 2 ? "🎉" : "💪")
                    .font(.system(size: 64))
 
                Text(correct == total ? "Perfect Score!" : "Session Complete!")
                    .font(.title2.bold())
 
                // Score breakdown
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("\(correct)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.green)
                        Text("Correct")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
 
                    Divider().frame(height: 50)
 
                    VStack(spacing: 4) {
                        Text("\(incorrect)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.red)
                        Text("Incorrect")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
 
                LexoraButton(title: "Play Again") {
                    onRestart()
                }
                .padding(.horizontal, 16)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding(32)
        }
    }
}
