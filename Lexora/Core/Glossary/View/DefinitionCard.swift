//
//  DefinitionCard.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct DefinitionCard: View {
    let language: String
    let icon: String
    let definition: String
    let isRTL: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 3D bottom edge
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
            
            // Content
            VStack(alignment: isRTL ? .trailing : .leading, spacing: 10) {
                // Language label
                Label(language, systemImage: icon)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: isRTL ? .trailing : .leading)
                
                // Definition
                Text(definition)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(isRTL ? .trailing : .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
                    .frame(maxWidth: .infinity, alignment: isRTL ? .trailing : .leading)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
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
