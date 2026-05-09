//
//  GlossaryCard.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI
import NaturalLanguage

struct GlossaryCard: View {
    let term: String
    let definition: String
    let arabicTerm: String
    let arabicDefinition: String
    
    @State private var isExpanded = false
    @State private var isPressed  = false
    
    // Bookmark
    private var entry: GlossaryEntry? {
        GlossaryService.shared.entries.first {
            $0.englishTerm.lowercased() == term.lowercased()
        }
    }
    
    private var isBookmarked: Bool {
        BookmarkService.shared.isBookmarked(term)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.neutral100)
                .offset(y: isPressed ? 1 : 4)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.neutral100, lineWidth: 1.5)
                )
                .offset(y: isPressed ? 3 : 0)
            
            VStack(alignment: .leading, spacing: 8) {
                
                // Header row
                HStack(alignment: .center) {
                    // Term + part of speech
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(term)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color.neutral900)
                        
                        Text(term.partOfSpeech)
                            .font(.subheadline)
                            .foregroundColor(Color.primary950)
                    }
                    
                    Spacer()
                    
                    // Expand / Collapse arrow button
                    HStack(spacing: 12) {
                        Button {
                            if let entry {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    BookmarkService.shared.toggle(entry)
                                }
                            }
                        } label: {
                            Image(systemName: isBookmarked ? "star.fill" : "star")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(isBookmarked ? Color.ternary700 : Color.neutral700)
                                .scaleEffect(isBookmarked ? 1.15 : 1.0)
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                isExpanded.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color.neutral700)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isExpanded)
                        }
                    }
                }
                
                // Collapsed: short definition
                Text(definition)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(isExpanded ? nil : 1)
                
                // Arabic term (always visible)
                Text("AR: \(arabicTerm)")
                    .font(.subheadline)
                    .foregroundColor(Color.primary950)
                    .environment(\.layoutDirection, .rightToLeft)
                
                // Expanded extra content
                if isExpanded {
                    Divider()
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Arabic Definition")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        Text(arabicDefinition)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .fixedSize(horizontal: false, vertical: true)
                            .transition(.opacity)
                    }
                }
            }
            .padding(16)
            .offset(y: isPressed ? 3 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        // Total height accounts for 3D edge
        .padding(.bottom, 4)
        .animation(.spring(response: 0.18, dampingFraction: 0.65), value: isPressed)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            GlossaryCard(
                term: "A/B Testing",
                definition: "Statistical way to compare two or more techniques to determine which performs better.",
                arabicTerm: "اختبار أ/ب",
                arabicDefinition: "طريقة إحصائية لمقارنة أسلوبين أو أكثر؛ لتحديد أي منهما يعمل بطريقة أفضل، وفهم ما إذا كان الاختلاف ذا دلالة إحصائية."
            )
            
            GlossaryCard(
                term: "Neural Network",
                definition: "A series of algorithms that mimic the operations of a human brain to recognize relationships.",
                arabicTerm: "شبكة عصبية",
                arabicDefinition: "انظر شبكة عصبية اصطناعية."
            )
        }
        .padding(20)
    }
    .background(Color.white)
}
