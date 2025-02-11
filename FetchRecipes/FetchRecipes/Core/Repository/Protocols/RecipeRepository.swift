//
//  RecipeRepository.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

protocol RecipeRepository: Sendable{
    func getAll() async throws -> [Recipe]
}
