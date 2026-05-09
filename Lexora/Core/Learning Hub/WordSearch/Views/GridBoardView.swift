//
//  GridBoardView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct GridBoardView: View {
    let viewModel: WordSearchViewModel
    
    var body: some View {
        GeometryReader { geo in
            let cellSize = geo.size.width / CGFloat(viewModel.grid.count)
            
            VStack(spacing: 0) {
                ForEach(0..<viewModel.grid.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.grid[row].count, id: \.self) { col in
                            let state = viewModel.cellState(row: row, col: col)
                            LetterCellView(
                                letter: viewModel.grid[row][col].letter,
                                state: state,
                                size: cellSize
                            )
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let startCol = Int(value.startLocation.x / cellSize)
                        let startRow = Int(value.startLocation.y / cellSize)
                        let currentPoint = value.location
                        
                        // Initialize origin on first change
                        if viewModel.selectedCells.isEmpty {
                            viewModel.startSelection(
                                row: startRow,
                                col: startCol,
                                point: value.startLocation
                            )
                        }
                        
                        viewModel.updateSelection(
                            currentPoint: currentPoint,
                            cellSize: cellSize
                        )
                    }
                    .onEnded { _ in
                        viewModel.commitSelection()
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray6))
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
