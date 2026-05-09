//
//  CornerBracketsView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct CornerBracketsView: View {
    let size: CGFloat
    let lineLength: CGFloat = 28
    let lineWidth: CGFloat = 3
    let color = Color.primary700
    
    var body: some View {
        ZStack {
            // Top-left
            Path { p in
                p.move(to: CGPoint(x: -size/2, y: -size/2 + lineLength))
                p.addLine(to: CGPoint(x: -size/2, y: -size/2))
                p.addLine(to: CGPoint(x: -size/2 + lineLength, y: -size/2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            // Top-right
            Path { p in
                p.move(to: CGPoint(x: size/2 - lineLength, y: -size/2))
                p.addLine(to: CGPoint(x: size/2, y: -size/2))
                p.addLine(to: CGPoint(x: size/2, y: -size/2 + lineLength))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            // Bottom-left
            Path { p in
                p.move(to: CGPoint(x: -size/2, y: size/2 - lineLength))
                p.addLine(to: CGPoint(x: -size/2, y: size/2))
                p.addLine(to: CGPoint(x: -size/2 + lineLength, y: size/2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            // Bottom-right
            Path { p in
                p.move(to: CGPoint(x: size/2 - lineLength, y: size/2))
                p.addLine(to: CGPoint(x: size/2, y: size/2))
                p.addLine(to: CGPoint(x: size/2, y: size/2 - lineLength))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        }
    }
}
