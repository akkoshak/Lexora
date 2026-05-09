//
//  WordOfTheDaySection.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct WordOfTheDaySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("Word of the Day")
                        .font(.system(size: 20, weight: .bold))
                }
                
                Spacer()
                
                Text(Date(), format: .dateTime.month(.abbreviated).day())
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.primary700)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.primary700.opacity(0.1))
                    .clipShape(Capsule())
            }
 
            if let entry = WordOfTheDayService.todaysWord() {
                WordOfTheDayCard(entry: entry)
            }
 
            // Daily Streak underneath
            DailyStreakView()
        }
    }
}

#Preview {
    ScrollView {
        WordOfTheDaySection()
            .padding(20)
    }
    .background(Color(.systemGray6))
}
