//
//  LexoraButton.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/5/26.
//

import SwiftUI

struct LexoraButton: View {
    var title = "Let's Start"
    var action: () -> Void = { }
    
    @State private var isPressed = false
    
    private let shadowColor = Color(hex: "#3E8CB2")
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isPressed ? Color.white : shadowColor)
                    .offset(y: isPressed ? 1 : 4)
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.primary700)
                    .overlay(glossOverlay)
                    .offset(y: isPressed ? 3 : 0)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .offset(y: isPressed ? 3 : 0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
//            .animation(.spring(response: 0.18, dampingFraction: 0.65), value: isPressed)
        }
        .buttonStyle(PressDownStyle(isPressed: $isPressed))
    }
    
    // Gloss highlight overlay
    private var glossOverlay: some View {
        HStack(spacing: 6) {
            Rectangle()
                .frame(width: 14, height: 80)
                .foregroundStyle(.white)
                .opacity(0.3)
                .rotationEffect(.degrees(20))
            
            Rectangle()
                .frame(width: 5, height: 80)
                .foregroundStyle(.white)
                .opacity(0.2)
                .rotationEffect(.degrees(20))
            
            Spacer()
        }
        .padding(.leading, 20)
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

private extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    LexoraButton()
}
