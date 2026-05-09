//
//  EmptyBookmarksView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct EmptyBookmarksView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.primary700.opacity(0.1))
                    .frame(width: 100, height: 100)
 
                Image(systemName: "star.slash")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.primary700.opacity(0.6))
            }
 
            VStack(spacing: 8) {
                Text("No saved words yet")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
 
                Text("Tap the ★ on any word in the\nDictionary to save it here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(40)
    }
}

#Preview {
    EmptyBookmarksView()
}
