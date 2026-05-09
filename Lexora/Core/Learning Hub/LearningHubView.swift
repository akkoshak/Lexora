//
//  LearningHubView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct LearningHubView: View {
    @Environment(Router.self) var router
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "graduationcap")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundStyle(Color.neutral700)
                
                Text("Learning Hub")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 24) {
                OutlinedButton {
                    router.navigateToWordSearch()
                } content: {
                    VStack(spacing: 8) {
                        Image(systemName: "puzzlepiece.extension.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .foregroundStyle(Color.secondary950)
                        
                        VStack {
                            Text("Word Search")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.neutral900)
                            
                            Text("Find words, beat the clock")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.ternary700)
                        }
                    }
                }
                .frame(height: 132)
                
                OutlinedButton {
                    router.navigateToFlashcards()
                } content: {
                    VStack(spacing: 8) {
                        Image(systemName: "menucard.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .foregroundStyle(Color.primary700)
                        
                        VStack {
                            Text("Flashcards")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.neutral900)
                            
                            Text("Test your knowledge, one card at a time")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.primary950)
                        }
                    }
                }
                .frame(height: 132)
            }
            .padding(.horizontal, 16)
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
    }
}

#Preview {
    @Previewable @State var router = Router()
    
    LearningHubView()
        .withRouter(router: router, hideTabBar: .constant(false))
}
