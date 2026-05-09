//
//  DetectedWordCardView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct DetectedWordCardView: View {
    let entry: GlossaryEntry
    let onScanAgain: () -> Void
 
    @State private var isPressed = false
 
    private let edgeColor = Color(.systemGray3)
    private let borderColor = Color(.systemGray4)
 
    var body: some View {
        ZStack {
            // 3D edge
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(edgeColor)
                .offset(y: 4)
 
            // Card face
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(borderColor, lineWidth: 1.5)
                )
 
            // Content
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(entry.englishTerm)
                        .font(.system(.title3, weight: .bold))
                    
                    Text(entry.englishTerm.partOfSpeech)
                        .font(.subheadline)
                        .foregroundColor(Color.primary700)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
 
                Text(entry.englishDefinition)
                    .font(.body)
                    .foregroundColor(.secondary)
 
                Text(entry.arabicTerm)
                    .font(.subheadline)
                    .foregroundColor(Color.primary700)
 
                Divider()
 
                // Scan Again button
                Button(action: onScanAgain) {
                    Label("Scan Again", systemImage: "arrow.triangle.2.circlepath")
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundColor(Color.primary700)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
    }
}

#Preview {
    let entry = GlossaryEntry(
        englishTerm: "Xception",
        englishDefinition: "A convolutional neural network architecture based on depthwise separable convolution layers.",
        arabicTerm: "إكسسيبشن",
        arabicDefinition: "استخدام تقنيات الذكاء الاصطناعي لأتمتة المهام التي تتطلب قدرات إدراكية بشرية."
    )
    
    DetectedWordCardView(entry: entry) {
        
    }
}
