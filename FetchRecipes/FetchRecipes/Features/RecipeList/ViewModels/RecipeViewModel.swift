//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    nonisolated private let recipeService: RecipeServiceProtocol
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes() async throws {
        isLoading = true
        try await Task.sleep(for: .seconds(6))
        do {
            let fetchedRecipes = try await recipeService.fetchRecipes(endpoint: .fetchAllRecipes)
            recipes = fetchedRecipes.sorted { $0.name < $1.name }
            isLoading = false
        } catch {
            print("Error fetching recipes: \(error)")
            isLoading = false
            throw error
            
        }
    }
}

