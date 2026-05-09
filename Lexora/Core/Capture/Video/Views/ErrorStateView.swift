//
//  ErrorStateView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
 
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.title3.bold())
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            LexoraButton(title: "Try Again") {
                onRetry()
            }
            .padding(.horizontal, 48)
            
            Spacer()
        }
    }
}

#Preview {
    ErrorStateView(message: "An error has occurred", onRetry: {
        
    })
}
