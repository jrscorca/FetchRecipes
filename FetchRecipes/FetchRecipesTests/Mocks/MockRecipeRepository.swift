//
//  MockRecipeRepository.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation
@testable import FetchRecipes

actor MockRecipeRepository: RecipeRepository {
    private var mockRecipes: [Recipe] = []
    private var error: Error?

    func setMockRecipes(_ recipes: [Recipe]) {
        self.mockRecipes = recipes
    }
    
    func setMockError(_ error: Error?) {
        self.error = error
    }
    
    func getAll() async throws -> [Recipe] {
        if let error = error {
            throw error
        }
        return mockRecipes
    }
}
