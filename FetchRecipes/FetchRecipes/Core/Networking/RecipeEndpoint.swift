//
//  RecipeEndpoint.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

enum RecipeEndpoint {
    case fetchAllRecipes
    
    #if DEBUG
    case integrationMalformed
    case integrationEmpty
    #endif
    
    var url: URL? {
        let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
        
        switch self {
        case .fetchAllRecipes:
            return URL(string: "\(baseURL)/recipes.json")
            
        #if DEBUG
        case .integrationMalformed:
            return URL(string: "\(baseURL)/recipes-malformed.json")
        case .integrationEmpty:
            return URL(string: "\(baseURL)/recipes-empty.json")
        #endif
        }
    }
    
    var method: String {
        switch self {
        case .fetchAllRecipes:
            return "GET"
            
        #if DEBUG
        case .integrationMalformed,
             .integrationEmpty:
            return "GET"
        #endif
        }
    }
}
