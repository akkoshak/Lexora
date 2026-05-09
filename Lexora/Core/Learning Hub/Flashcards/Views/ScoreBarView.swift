//
//  ScoreBarView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct ScoreBarView: View {
    let correct: Int
    let incorrect: Int
    let current: Int
    let total: Int
    
    var body: some View {
        HStack {
            // Correct
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                Text("\(correct)")
                    .font(.system(.body, weight: .bold))
                    .foregroundColor(.green)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.1))
            .clipShape(Capsule())
            
            Spacer()
            
            // Card counter
            Text("\(current) / \(total)")
                .font(.system(.subheadline, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Incorrect
            HStack(spacing: 6) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                
                Text("\(incorrect)")
                    .font(.system(.body, weight: .bold))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.1))
            .clipShape(Capsule())
        }
    }
}

#Preview {
    ScoreBarView(correct: 3, incorrect: 2, current: 5, total: 10)
}
