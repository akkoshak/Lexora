//
//  TranscribingView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import Combine

struct TranscribingView: View {
    @State private var dots = ""
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
 
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .scaleEffect(1.6)
                .tint(Color.primary700)
            
            Text("Transcribing video\(dots)")
                .font(.title3.bold())
            
            Text("This may take a moment...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .onReceive(timer) { _ in
            dots = dots.count < 3 ? dots + "." : ""
        }
    }
}

#Preview {
    TranscribingView()
}
