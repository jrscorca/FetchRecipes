//
//  MockImageRepository.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/11/25.
//

import SwiftUI
@testable import FetchRecipes

actor MockImageRepository: ImageRepository {
    
    var mockImageData: [URL: Data] = [:]
    var mockCachedData: [URL: Data] = [:]
    var error: Error?
    var cancelledURLs: Set<URL> = []
    
    // Helper to set up mock data
    func setMockImageData(_ data: Data, for url: URL) {
        mockImageData[url] = data
    }
    
    func setCachedData(_ data: Data, for url: URL) {
        mockCachedData[url] = data
    }
    
    func get(from url: URL) async throws -> UIImage? {
        if let error = error {
            throw error
        }
        
        // Check mock cache first
        if let cachedData = mockCachedData[url] {
            return UIImage(data: cachedData)
        }
        
        // Simulate network fetch
        guard let data = mockImageData[url] else {
            throw URLError(.resourceUnavailable)
        }
        
        // Simulate cache save
        mockCachedData[url] = data
        return UIImage(data: data)
    }
    
    func cancelFetch(for url: URL) async {
        cancelledURLs.insert(url)
    }
    
}
