//
//  ScanningHintView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct ScanningHintView: View {
    var body: some View {
        Text("Point at an AI term to scan")
            .font(.system(.subheadline, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.5))
            .clipShape(Capsule())
    }
}

#Preview {
    ScanningHintView()
}
