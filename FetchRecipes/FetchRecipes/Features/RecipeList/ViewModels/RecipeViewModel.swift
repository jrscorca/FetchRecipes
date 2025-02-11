//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    nonisolated private let recipeRepository: RecipeRepository
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading: Bool = false
    @Published var error: Error?
    
    init(recipeRepository: RecipeRepository = DefaultRecipeRepository(service: RecipeService())) {
        self.recipeRepository = recipeRepository
    }
    
    func fetchRecipes() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        do {
            let fetchedRecipes = try await recipeRepository.getAll()
            recipes = fetchedRecipes.sorted { $0.name < $1.name }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

