//
//  RecipeServiceProtocol.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import Foundation

protocol RecipeServiceProtocol: Sendable {
    func fetchRecipes(endpoint: RecipeEndpoint) async throws -> [Recipe]
}
