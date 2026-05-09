//
//  HomeView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            WordOfTheDaySection()
                .padding(20)
        }
        .background(Color.body)
    }
}

#Preview {
    HomeView()
}
