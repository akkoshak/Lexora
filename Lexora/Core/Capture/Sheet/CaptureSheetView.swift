//
//  CaptureSheetView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct CaptureSheetView: View {
    @State private var isPresented = false
    
    var onCamera: () -> Void = {}
    var onVoice: () -> Void = {}
    var onVideo: () -> Void = {}
    
    private let options: [CaptureOption] = [
        CaptureOption(
            title: "Scan a Word",
            subtitle: "Point your camera at any word",
            icon: "camera.fill",
            iconColor: Color.primary800
        ),
        CaptureOption(
            title: "Say a Word",
            subtitle: "Speak a word to find its definition",
            icon: "mic.fill",
            iconColor: Color.error500
        ),
        CaptureOption(
            title: "Upload a Video",
            subtitle: "Detect glossary words from a video",
            icon: "play.rectangle.fill",
            iconColor: Color.success500
        )
    ]
 
    var body: some View {
        ZStack {
            // 3D bottom edge
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.neutral100)
                .offset(y: 4)
            
            // Card face
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.neutral100, lineWidth: 2)
                )
            
            // Content
            VStack(spacing: 2) {
                ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                    CaptureOptionRow(option: option) {
                        isPresented = false
                        switch index {
                        case 0: onCamera()
                        case 1: onVoice()
                        case 2: onVideo()
                        default: break
                        }
                    }
                    
                    if index < options.count - 1 {
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .padding(.horizontal, 16)
    }
}

#Preview {
    CaptureSheetView()
}
