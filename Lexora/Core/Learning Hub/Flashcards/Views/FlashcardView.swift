//
//  FlashcardView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct FlashcardView: View {
    @Environment(Router.self) private var router
    
    @State private var viewModel = FlashcardViewModel()
 
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                BackButton {
                    router.popToRoot()
                }
                
                Text("Flashcards")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                ScoreBarView(
                    correct: viewModel.correctCount,
                    incorrect: viewModel.incorrectCount,
                    current: viewModel.currentIndex + 1,
                    total: viewModel.totalCards
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                ProgressBarView(progress: viewModel.progress)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                Spacer()
                
                if let card = viewModel.currentCard {
                    FlashcardCardView(card: card, answerState: viewModel.answerState)
                        .padding(.horizontal, 16)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .id(card.id)
                    
                    Spacer()
                    
                    OptionsGridView(card: card, answerState: viewModel.answerState) { selected in
                        viewModel.select(option: selected)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
        .onAppear {
            viewModel.startSession()
        }
        .overlay {
            if viewModel.isSessionComplete {
                SessionCompleteOverlay(
                    correct: viewModel.correctCount,
                    incorrect: viewModel.incorrectCount,
                    total: viewModel.totalCards) {
                        viewModel.startSession()
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentIndex)
    }
}

#Preview {
    @Previewable @State var router = Router()
    
    FlashcardView()
        .withRouter(router: router, hideTabBar: .constant(true))
}
