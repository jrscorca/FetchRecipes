//
//  RecipeService.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

actor RecipeService: RecipeServiceProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetchRecipes(endpoint: RecipeEndpoint = .fetchAllRecipes) async throws -> [RecipeDTO] {
        
        guard let url = endpoint.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        do {
            let (data, response) = try await client.getData(for: request)
            
            guard (200...299).contains(response.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipesResponse = try decoder.decode(RecipesResponse.self, from: data)
            return recipesResponse.recipes
            
        }
    }
}
