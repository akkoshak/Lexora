//
//  IdleUploadView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct IdleUploadView: View {
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.primary700.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "video.badge.plus")
                    .font(.system(size: 48))
                    .foregroundColor(Color.primary700)
            }
            
            VStack(spacing: 8) {
                Text("Upload a Video")
                    .font(.title3.bold())
                
                Text("Select a video to detect AI terms\nfrom the speech in real-time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            LexoraButton(title: "Choose Video") {
                onTap()
            }
            .padding(.horizontal, 48)
            
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    IdleUploadView {
        
    }
}
