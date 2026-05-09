//
//  FlashcardCardView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct FlashcardCardView: View {
    let card: Flashcard
    let answerState: AnswerState
 
    @State private var isPressed = false
 
    private let borderColor = Color(.systemGray4)
    private let edgeColor   = Color(.systemGray3)
 
    var body: some View {
        ZStack {
            // 3D bottom edge
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(edgeColor)
                .offset(y: 4)
 
            // Card face
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(borderColor, lineWidth: 1.5)
                )
 
            // Content
            VStack(spacing: 16) {
                Text("What word matches this definition?")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .leading)
 
                Text(card.entry.englishDefinition)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
 
                if answerState != .unanswered {
                    Divider()
 
                    HStack(spacing: 8) {
                        Image(systemName: answerState == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(answerState == .correct ? .green : .red)
 
                        Text(card.entry.englishTerm)
                            .font(.system(.body, weight: .bold))
                            .foregroundColor(answerState == .correct ? .green : .red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
        .animation(.spring(response: 0.3), value: answerState)
    }
}
