//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    private let recipeRepository: RecipeRepository
    
    private(set) var recipes: [Recipe] = []
    
    @Published private(set) var sectionedRecipes: [String: [Recipe]] = [:]
    @Published private(set) var sections: [String] = []
    @Published private(set) var isLoading: Bool = false
    @Published var error: Error?
    @Published var searchText = "" {
        didSet {
            filterRecipes()
        }
    }
    
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
            filterRecipes()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    private func filterRecipes() {
        let filteredRecipes = recipes.filter { recipe in
            guard !searchText.isEmpty else { return true }
            return recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
        
        sectionedRecipes = Dictionary(grouping: filteredRecipes) { $0.cuisine }
        sections = sectionedRecipes.keys.sorted()
    }
}

