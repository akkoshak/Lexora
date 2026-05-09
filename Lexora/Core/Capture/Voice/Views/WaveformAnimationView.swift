//
//  WaveformAnimationView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct WaveformAnimationView: View {
    @State private var animate = false
    
    private let barCount = 7
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { i in
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.primary700)
                    .frame(width: 4)
                    .frame(height: animate ? CGFloat.random(in: 12...44) : 8)
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.3...0.6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.08), value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    WaveformAnimationView()
}
