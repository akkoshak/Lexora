//
//  PlusTabButton.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct PlusTabButton: View {
    let isActive: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.primary950)
                    .frame(width: 60, height: 60)
                    .offset(y: isPressed ? 1 : 4)
                
                Circle()
                    .fill(Color.primary700)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color.primary700.opacity(0.6), lineWidth: 1.5)
                    )
                    .offset(y: isPressed ? 3 : 0)
                
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isActive ? 45 : 0))
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isActive)
                    .offset(y: isPressed ? 3 : 0)
            }
            .frame(width: 60, height: 68) // extra height for 3D edge
            .animation(.spring(response: 0.18, dampingFraction: 0.65), value: isPressed)
        }
        .buttonStyle(PressDownStyle(isPressed: $isPressed))
    }
}

private struct PressDownStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newVal in isPressed = newVal }
    }
}

#Preview {
    @Previewable @State var showCapture = false
    
    PlusTabButton(isActive: showCapture) {
        
    }
}
