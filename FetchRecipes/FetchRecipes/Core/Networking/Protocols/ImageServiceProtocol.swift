//
//  ImageServiceProtocol.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

protocol ImageServiceProtocol: Sendable {
    func fetchImageData(url: URL) async throws -> Data
    func cancelFetch(url: URL) async
}
