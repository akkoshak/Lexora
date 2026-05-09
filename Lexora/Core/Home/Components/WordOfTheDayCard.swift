//
//  WordOfTheDayCard.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct WordOfTheDayCard: View {
    let entry: GlossaryEntry
 
    @State private var isExpanded = false
    @State private var isPressed  = false
    @State private var appeared   = false
 
    private let primaryColor = Color.primary700
    private let edgeColor = Color.primary950
 
    var body: some View {
        ZStack(alignment: .topLeading) {
            // ── 3D bottom edge ──
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(edgeColor)
                .offset(y: isPressed ? 1 : 4)
 
            // ── Card face ──
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [primaryColor, edgeColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.25), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                )
                .offset(y: isPressed ? 3 : 0)
 
            // ── Content ──
            VStack(alignment: .leading, spacing: 12) {
 
                // Badge
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10, weight: .bold))
                    Text("Word of the Day")
                        .font(.system(size: 11, weight: .bold))
                        .textCase(.uppercase)
                        .kerning(1.2)
                }
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : -8)
 
                // Term + POS
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(entry.englishTerm)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
 
                    Text(entry.englishTerm.partOfSpeech)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.75))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
 
                // Arabic term
                Text(entry.arabicTerm)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .environment(\.layoutDirection, .rightToLeft)
                    .opacity(appeared ? 1 : 0)
 
                Divider()
                    .background(Color.white.opacity(0.3))
                    .opacity(appeared ? 1 : 0)
 
                // Definition — key fix: no fixed frame, grows naturally
                Text(entry.englishDefinition)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(isExpanded ? nil : 3)
                    .fixedSize(horizontal: false, vertical: true) // lets text grow vertically
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
 
                // Read more / Show less
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isExpanded ? "Show less" : "Read more")
                            .font(.system(size: 13, weight: .semibold))
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
                    }
                    .foregroundColor(.white.opacity(0.85))
                }
                .opacity(appeared ? 1 : 0)
            }
            .padding(20)
            .offset(y: isPressed ? 3 : 0)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
        .animation(.spring(response: 0.18, dampingFraction: 0.65), value: isPressed)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
        }
    }
}
