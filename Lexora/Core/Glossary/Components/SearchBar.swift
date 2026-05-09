//
//  SearchBar.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Enter a word"
     
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isPressed ? Color.white : Color.neutral100)
                .offset(y: isPressed ? 1 : 4)
            
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.neutral100, lineWidth: 1.5)
                )
                .offset(y: isPressed ? 3 : 0)
            
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(Color.neutral700)
                
                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.neutral900)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .offset(y: isPressed ? 3 : 0)
        }
        .frame(height: 54) // 50px face + 4px edge + breathing room
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        withAnimation(.spring(response: 0.18, dampingFraction: 0.65)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.18, dampingFraction: 0.65)) {
                        isPressed = false
                    }
                }
        )
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: text.isEmpty)
    }
}

#Preview {
    @Previewable @State var query = ""
 
    VStack(spacing: 32) {
        // Empty state
        SearchBar(text: $query)
 
        // With text
        SearchBar(text: .constant("Neural Network"))
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.body)
}
