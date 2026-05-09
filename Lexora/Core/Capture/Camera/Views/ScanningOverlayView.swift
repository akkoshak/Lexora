//
//  ScanningOverlayView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct ScanningOverlayView: View {
    let isScanning: Bool
 
    @State private var scanLine: CGFloat = 0
 
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width * 0.7, 280.0)
            let y = (geo.size.height - size) / 2.5
 
            ZStack {
                // Dimmed background with cutout
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .mask(
                        Rectangle()
                            .ignoresSafeArea()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: size, height: size)
                                    .position(x: geo.size.width / 2, y: y + size / 2)
                                    .blendMode(.destinationOut)
                            )
                            .compositingGroup()
                    )
 
                // Animated scan line
                if isScanning {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.primary700.opacity(0.8), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: size - 8, height: 2)
                        .position(x: geo.size.width / 2, y: y + scanLine)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                                scanLine = size
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ScanningOverlayView(isScanning: true)
}
