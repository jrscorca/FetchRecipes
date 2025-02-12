//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

struct Recipe: Identifiable {
    let id: String
    let name: String
    let cuisine: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?
    
    init(dto: RecipeDTO) {
        self.id = dto.uuid
        self.name = dto.name
        self.cuisine = dto.cuisine
        self.photoUrlSmall = URL(string: dto.photoUrlSmall ?? "")
        self.photoUrlLarge = URL(string: dto.photoUrlLarge ?? "")
        self.sourceUrl = URL(string: dto.sourceUrl ?? "")
        self.youtubeUrl = URL(string: dto.youtubeUrl ?? "")
    }
}
