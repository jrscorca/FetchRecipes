//
//  RecipeService.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

actor RecipeService: RecipeServiceProtocol {
    
    func fetchRecipes(endpoint: RecipeEndpoint = .fetchAllRecipes) async throws -> [RecipeDTO] {
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipesResponse = try decoder.decode(RecipesResponse.self, from: data)
            return recipesResponse.recipes
            
        } catch let error as DecodingError {
            print(error.localizedDescription)
            throw NetworkError.decodingFailed
        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed(error)
        }
    }
}
