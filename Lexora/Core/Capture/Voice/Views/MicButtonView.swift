//
//  MicButtonView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct MicButtonView: View {
    let isListening: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            // Pulse ring when listening
            if isListening {
                Circle()
                    .stroke(Color.primary700.opacity(0.3), lineWidth: 2)
                    .frame(width: pulse ? 110 : 90, height: pulse ? 110 : 90)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
                
                Circle()
                    .stroke(Color.primary700.opacity(0.15), lineWidth: 2)
                    .frame(width: pulse ? 135 : 110, height: pulse ? 135 : 110)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.2), value: pulse)
            }
            
            Button(action: action) {
                ZStack {
                    // 3D edge
                    Circle()
                        .fill(isListening ? Color.red.opacity(0.6) : Color.primary950)
                        .frame(width: 80, height: 80)
                        .offset(y: isPressed ? 1 : 4)
                    
                    // Face
                    Circle()
                        .fill(isListening ? Color.red : Color.primary700)
                        .frame(width: 80, height: 80)
                        .offset(y: isPressed ? 3 : 0)
                    
                    Image(systemName: isListening ? "stop.fill" : "mic.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(y: isPressed ? 3 : 0)
                }
                .frame(width: 80, height: 88)
                .animation(.spring(response: 0.3), value: isListening)
            }
            .buttonStyle(PressDownStyle(isPressed: $isPressed))
        }
        .onAppear { pulse = true }
        .onChange(of: isListening) { _, listening in
            pulse = listening
        }
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

#Preview {
    MicButtonView(isListening: false) {
        
    }
}
