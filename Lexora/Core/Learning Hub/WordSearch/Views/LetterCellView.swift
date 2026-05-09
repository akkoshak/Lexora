//
//  LetterCellView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct LetterCellView: View {
    let letter: Character
    let state: CellState
    let size: CGFloat
    
    var body: some View {
        Text(String(letter))
            .font(.system(size: size * 0.45, weight: .semibold, design: .monospaced))
            .foregroundColor(foregroundColor)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .animation(.easeInOut(duration: 0.15), value: state)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .normal:    return Color.clear
        case .selected:  return Color.primary700.opacity(0.3)
        case .found:     return Color.primary700
        case .incorrect: return Color.red.opacity(0.3)
        }
    }
    
    private var foregroundColor: Color {
        switch state {
        case .found:    return Color.white
        default:        return Color.primary
        }
    }
}
