//
//  CaptureOptionRow.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct CaptureOptionRow: View {
    let option: CaptureOption
    let action: () -> Void
 
    @State private var isPressed = false
 
    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: option.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(option.iconColor)
                    
                    VStack(alignment: .leading) {
                        Text(option.title)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.neutral900)
                        
                        Text(option.subtitle)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.neutral600)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundColor(Color.neutral700)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 70)
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
    let option = CaptureOption(
        title: "Scan a Word",
        subtitle: "Point your camera at any word",
        icon: "camera.fill",
        iconColor: Color.primary800,
    )
    
    CaptureOptionRow(option: option) {
        
    }
}
