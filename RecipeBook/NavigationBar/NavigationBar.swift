//
//  NavigationBar.swift
//  RecipeBook
//
//  Created by AnhDuc on 05/05/2024.
//

import SwiftUI

struct NavigationBar<Content: View>: View {
    var content: Content

    init(_ content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.orange, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .navigationSplitViewStyle(.balanced)
    }
}
