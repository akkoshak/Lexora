//
//  WordSearchView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct WordSearchView: View {
    @Environment(Router.self) private var router
    
    @State private var viewModel = WordSearchViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                BackButton {
                    router.popToRoot()
                }
                
                Text("Word Search")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 20) {
                Text("Find the hidden words:")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                // Grid
                GridBoardView(viewModel: viewModel)
                    .padding(.horizontal, 16)
                
                WordListView(placedWords: viewModel.placedWords, foundIndices: viewModel.foundIndices)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                LexoraButton(title: "New Game") {
                    viewModel.startNewGame()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
        .onAppear {
            viewModel.startNewGame()
        }
        .overlay {
            if viewModel.isGameComplete {
                GameCompleteOverlay {
                    viewModel.startNewGame()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var router = Router()
    
    WordSearchView()
        .withRouter(router: router, hideTabBar: .constant(true))
}
