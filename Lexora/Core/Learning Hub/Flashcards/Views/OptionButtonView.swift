//
//  OptionButtonView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct OptionButtonView: View {
    let option: GlossaryEntry
    let answerState: AnswerState
    let correctId: UUID
    let onSelect: (GlossaryEntry) -> Void
 
    @State private var isPressed = false
 
    private var isCorrect: Bool { option.id == correctId }
 
    private var backgroundColor: Color {
        guard answerState != .unanswered else { return Color(.systemGray6) }
        if isCorrect { return Color.green.opacity(0.15) }
        if case .incorrect(let selected) = answerState, selected == option.englishTerm {
            return Color.red.opacity(0.15)
        }
        return Color(.systemGray6)
    }
 
    private var borderColor: Color {
        guard answerState != .unanswered else { return Color(.systemGray4) }
        if isCorrect { return Color.green }
        if case .incorrect(let selected) = answerState, selected == option.englishTerm {
            return Color.red
        }
        return Color(.systemGray4)
    }
 
    private var textColor: Color {
        guard answerState != .unanswered else { return .primary }
        if isCorrect { return .green }
        if case .incorrect(let selected) = answerState, selected == option.englishTerm {
            return .red
        }
        return .secondary
    }
 
    var body: some View {
        Button {
            guard answerState == .unanswered else { return }
            onSelect(option)
        } label: {
            ZStack {
                // 3D edge
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(borderColor.opacity(0.4))
                    .offset(y: isPressed ? 1 : 3)
 
                // Face
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(borderColor, lineWidth: 1.5)
                    )
                    .offset(y: isPressed ? 2 : 0)
 
                Text(option.englishTerm)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 14)
                    .offset(y: isPressed ? 2 : 0)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 56)
            .animation(.spring(response: 0.18, dampingFraction: 0.65), value: isPressed)
            .animation(.easeInOut(duration: 0.2), value: answerState)
        }
        .buttonStyle(PressDownStyle(isPressed: $isPressed))
        .disabled(answerState != .unanswered)
    }
}

private struct PressDownStyle: ButtonStyle {
    @Binding var isPressed: Bool
 
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newVal in
                isPressed = newVal
            }
    }
}
