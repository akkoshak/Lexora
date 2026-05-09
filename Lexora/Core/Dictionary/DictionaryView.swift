//
//  DictionaryView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct DictionaryView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "text.book.closed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundStyle(Color.neutral700)
                
                Text("Dictionary")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            GlossaryView()
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
    }
}

#Preview {
    DictionaryView()
}
