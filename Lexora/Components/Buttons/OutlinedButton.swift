//
//  OutlinedButton.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct OutlinedButton<Content: View>: View {
    var action: () -> Void = { }
    @ViewBuilder var content: () -> Content
 
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 3D bottom edge
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isPressed ? Color.white : Color.neutral100)
                    .offset(y: isPressed ? 1 : 4)
                
                // Card face
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.neutral100, lineWidth: 2)
                    )
                    .offset(y: isPressed ? 3 : 0)
                
                // Content
                content()
                    .offset(y: isPressed ? 3 : 0)
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.18, dampingFraction: 0.65), value: isPressed)
        }
        .buttonStyle(PressDownStyle(isPressed: $isPressed))
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
    VStack(spacing: 60) {
        // Simple text (same as before)
        OutlinedButton {
            
        } content: {
            Text("Sign Up")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color.neutral900)
        }
        .frame(height: 54)
        
        // Rich content (like the screenshot)
        OutlinedButton {
            print("AI Dictionary tapped")
        } content: {
            VStack(spacing: 12) {
                Image(systemName: "character.book.closed.fill")
                    .font(.system(size: 44))
                    .foregroundColor(Color.primary700)
                
                Text("AI Dictionary")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("AI based dictionary")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color.primary700)
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 16)
        }
        .frame(height: 132)
    }
    .padding(.horizontal, 16)
}
