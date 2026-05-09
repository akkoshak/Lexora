//
//  ProgressBarView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double
 
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 6)
 
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary700)
                    .frame(width: geo.size.width * progress, height: 6)
                    .animation(.spring(response: 0.4), value: progress)
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    ProgressBarView(progress: 0.5)
}
