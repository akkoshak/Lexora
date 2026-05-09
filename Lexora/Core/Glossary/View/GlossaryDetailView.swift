//
//  GlossaryDetailView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct GlossaryDetailView: View {
    let entry: GlossaryEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // ── Header ──
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(entry.englishTerm)
                            .font(.system(.title, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(entry.englishTerm.partOfSpeech)
                            .font(.subheadline)
                            .foregroundColor(Color.primary700)
                    }
                    
                    Text(entry.arabicTerm)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .environment(\.layoutDirection, .rightToLeft)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                DefinitionCard(
                    language: "English",
                    icon: "textformat",
                    definition: entry.englishDefinition,
                    isRTL: false
                )
                .padding(.horizontal, 16)
                
                DefinitionCard(
                    language: "Arabic",
                    icon: "textformat.rtl",
                    definition: entry.arabicDefinition,
                    isRTL: true
                )
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 32)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationTitle(entry.englishTerm)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GlossaryDetailView(entry: GlossaryEntry(
            englishTerm: "Neural Network",
            englishDefinition: "A series of algorithms that mimic the operations of a human brain to recognize relationships between vast amounts of data.",
            arabicTerm: "شبكة عصبية",
            arabicDefinition: "سلسلة من الخوارزميات التي تحاكي عمليات الدماغ البشري للتعرف على العلاقات بين كميات هائلة من البيانات."
        ))
    }
}
