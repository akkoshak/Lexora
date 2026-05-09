//
//  DailyStreakView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct DailyStreakView: View {
    @AppStorage("streakCount") private var streakCount: Int = 0
    @AppStorage("lastOpenedDate") private var lastOpenedDate: String = ""
 
    @State private var appeared = false
    @State private var animateFlame = false
 
    private let primaryColor = Color.primary700
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
 
    private var todayIndex: Int {
        // 0 = Sunday in Calendar, shift to Mon = 0
        let weekday = Calendar.current.component(.weekday, from: Date())
        return (weekday + 5) % 7
    }
 
    var body: some View {
        ZStack {
            // 3D edge
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.neutral100)
                .offset(y: 4)
 
            // Card face
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.neutral100, lineWidth: 1.5)
                )
 
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Daily Streak")
                            .font(.system(size: 17, weight: .bold))
                        Text("Keep learning every day")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
 
                    Spacer()
 
                    // Flame + count
                    HStack(spacing: 4) {
                        Text("🔥")
                            .font(.system(size: 28))
                            .scaleEffect(animateFlame ? 1.2 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true),
                                value: animateFlame
                            )
                        Text("\(streakCount)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color.orange)
                        Text("days")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .padding(.top, 6)
                    }
                }
 
                // Day pills
                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { i in
                        VStack(spacing: 4) {
                            Text(days[i])
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(i == todayIndex ? primaryColor : .secondary)
 
                            ZStack {
                                Circle()
                                    .fill(i <= todayIndex
                                          ? primaryColor.opacity(0.15)
                                          : Color(.systemGray6))
                                    .frame(width: 34, height: 34)
 
                                if i < todayIndex {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(primaryColor)
                                } else if i == todayIndex {
                                    Circle()
                                        .fill(primaryColor)
                                        .frame(width: 34, height: 34)
                                    Text("★")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                } else {
                                    Circle()
                                        .strokeBorder(Color(.systemGray4), lineWidth: 1.5)
                                        .frame(width: 34, height: 34)
                                }
                            }
                            .scaleEffect(appeared ? 1 : 0.5)
                            .opacity(appeared ? 1 : 0)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.7)
                                .delay(Double(i) * 0.06),
                                value: appeared
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
        .onAppear {
            updateStreak()
            appeared = true
            animateFlame = true
        }
    }
 
    // MARK: - Streak Logic
 
    private func updateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
 
        if lastOpenedDate == today { return } // already counted today
 
        let yesterday = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
 
        if lastOpenedDate == yesterday {
            streakCount += 1 // consecutive day
        } else if lastOpenedDate != today {
            streakCount = 1  // streak broken, restart
        }
 
        lastOpenedDate = today
    }
}

#Preview {
    DailyStreakView()
}
