//
//  HTTPClient.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/11/25.
//

import Foundation

protocol HTTPClient: Sendable {
    func getData(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}


