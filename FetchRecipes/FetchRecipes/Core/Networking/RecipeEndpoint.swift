//
//  RecipeEndpoint.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import Foundation

enum RecipeEndpoint {
    case fetchAllRecipes
    case fetchMalformedRecipes
    case fetchEmptyRecipes
    
    var url: URL? {
        let baseURLString = "https://d3jbb8n5wk0qxi.cloudfront.net"
        switch self {
        case .fetchAllRecipes:
            return URL(string: "\(baseURLString)/recipes.json")
        case .fetchMalformedRecipes:
            return URL(string: "\(baseURLString)/recipes-malformed.json")
        case .fetchEmptyRecipes:
            return URL(string: "\(baseURLString)/recipes-empty.json")
        }
    }
    
    var method: String {
        switch self {
        case .fetchAllRecipes, .fetchEmptyRecipes, .fetchMalformedRecipes:
            return "GET"
        }
    }
}


