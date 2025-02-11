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
    
    func getById(_ id: String) async throws -> Recipe? {
        guard let dto = try await service.fetchRecipes(endpoint: .fetchAllRecipes).first(where: { $0.uuid == id }) else {return nil}
        return Recipe(dto: dto)
    }
    

    
}
