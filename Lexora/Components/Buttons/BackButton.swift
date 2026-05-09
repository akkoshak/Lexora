//
//  BackButton.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/5/26.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background with border
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(.neutral100), lineWidth: 1.5)
                    }
                    .shadow(color: .neutral100, radius: 0.1, x: 0, y: 2)
                
                Image(systemName: "arrow.backward")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(.neutral700)
            }
            .frame(width: 48, height: 48)
        }
        .buttonStyle(BackButtonStyle())
    }
}

private struct BackButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    BackButton {
        
    }
}
