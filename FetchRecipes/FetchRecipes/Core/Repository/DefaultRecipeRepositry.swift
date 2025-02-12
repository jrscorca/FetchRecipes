//
//  DefaultRecipeRepositry.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

actor DefaultRecipeRepository: RecipeRepository {
    private let service: RecipeServiceProtocol
    
    init(service: RecipeServiceProtocol) {
        self.service = service
    }
    
    func getAll() async throws -> [Recipe] {
        let dtos = try await service.fetchRecipes(endpoint: .fetchAllRecipes)
        return dtos.map { Recipe(dto: $0) }
    }
    
}
