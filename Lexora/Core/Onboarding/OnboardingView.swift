//
//  OnboardingView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/5/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @Binding var currentIndex: Int
    var onFinish: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                ForEach(Onboarding.screens.indices, id: \.self) { index in
                    screenView(size: size, index: index)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                OutlinedButton {
                    currentIndex += 1
                } content: {
                    Text("Next")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color.neutral900)
                }
                .frame(height: 54)
                .padding(.horizontal, 16)
                .offset(y: -80)
                .opacity(currentIndex > 1 ? 0 : 1)
            }
            .offset(y: showOnboarding ? 0 : size.height)
        }
    }
    
    @ViewBuilder
    private func screenView(size: CGSize, index: Int) -> some View {
        let screen = Onboarding.screens[index]
        
        VStack(spacing: 90) {
            VStack(spacing: 16) {
                Image(screen.image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 16)
                    .offset(x: -size.width * CGFloat(currentIndex - index))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
                
                HStack(spacing: 8) {
                    ForEach(0...2, id: \.self) { indicator in
                        if indicator == currentIndex {
                            Capsule()
                                .fill(Color.primary700)
                                .frame(width: 24, height: 6)
                        } else {
                            Circle()
                                .fill(Color.neutral100)
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: currentIndex)
            }
            .padding(.top, 70)
            
            VStack {
                Text(screen.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.horizontal, 24)
                    .offset(x: -size.width * CGFloat(currentIndex - index))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
                
                Text(screen.subtitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.9))
                    .offset(x: -size.width * CGFloat(currentIndex - index))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
                
                if currentIndex >= 2 {
                    LexoraButton(title: "Let's Start") {
                        onFinish()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 26)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    @Previewable @State var currentIndex = 0
    
    OnboardingView(showOnboarding: .constant(true), currentIndex: $currentIndex) {
        
    }
}
