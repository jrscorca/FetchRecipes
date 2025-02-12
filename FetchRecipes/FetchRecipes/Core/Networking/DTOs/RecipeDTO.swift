//
//  RecipeDTO.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

struct RecipeDTO: Decodable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
}

struct RecipesResponse: Decodable {
    let recipes: [RecipeDTO]
}
