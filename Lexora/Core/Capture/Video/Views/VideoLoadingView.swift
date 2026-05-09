//
//  VideoLoadingView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct VideoLoadingView: View {
    let progress: Double
 
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
 
            // Animated icon
            ZStack {
                Circle()
                    .fill(Color.primary700.opacity(0.1))
                    .frame(width: 100, height: 100)
 
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(Color.primary700)
            }
 
            VStack(spacing: 8) {
                Text("Uploading Video")
                    .font(.title3.bold())
 
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.primary700)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: progress)
            }
 
            // Progress bar
            VStack(spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.systemGray5))
                            .frame(height: 10)
 
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [Color.primary700, Color.primary950],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * progress, height: 10)
                            .animation(.spring(response: 0.3), value: progress)
                    }
                }
                .frame(height: 10)
            }
            .padding(.horizontal, 40)
 
            Spacer()
        }
        .padding(24)
    }
}
