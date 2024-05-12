//
//  RecipeBookApp.swift
//  RecipeBook
//
//  Created by AnhDuc on 05/05/2024.
//

import SwiftUI

@main
struct RecipeBookApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryView(viewModel: CategoryViewModel())
        }
    }
}
