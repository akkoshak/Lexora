//
//  StatsBarView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct StatsBarView: View {
    let count: Int
 
    var body: some View {
        ZStack {
            // 3D edge
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray3))
                .offset(y: 4)
 
            // Face
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray4), lineWidth: 1.5)
                )
 
            HStack(spacing: 0) {
                StatItemView(
                    icon: "star.fill",
                    iconColor: Color.primary700,
                    value: "\(count)",
                    label: "Saved"
                )
 
                Divider()
                    .frame(height: 36)
 
                StatItemView(
                    icon: "calendar",
                    iconColor: .orange,
                    value: todayDate,
                    label: "Last updated"
                )
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
    }
 
    private var todayDate: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f.string(from: Date())
    }
}

#Preview {
    StatsBarView(count: 2)
}
