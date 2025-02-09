//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    nonisolated private let recipeService: RecipeServiceProtocol
    @Published var recipes: [Recipe] = []
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes() async throws {
        do {
            recipes = try await recipeService.fetchRecipes(endpoint: .fetchAllRecipes)
        } catch {
            print("Error fetching recipes: \(error)")
            throw error
            
        }
    }
}

