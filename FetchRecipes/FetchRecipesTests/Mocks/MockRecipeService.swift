//
//  MockRecipeService.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation
@testable import FetchRecipes

actor MockRecipeService: RecipeServiceProtocol {
    var mockRecipes: [RecipeDTO] = []
    var error: Error?
    
    func fetchRecipes(endpoint: RecipeEndpoint) async throws -> [RecipeDTO] {
        if let error = error {
            throw error
        }
        return mockRecipes
    }
}
