//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeView(viewModel: RecipeViewModel())
        }
    }
}
