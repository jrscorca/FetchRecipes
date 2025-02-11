//
//  MockHTTPClient.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/11/25.
//

import Foundation
@testable import FetchRecipes

actor MockHTTPClient: HTTPClient {
    
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    var mockError: Error?
    
    func getData(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData,
              let response = mockResponse else {
            throw URLError(.unknown)
        }
        
        return (data, response)
    }
    
    func setMockData(_ data: Data?) {
        self.mockData = data
    }
    
    func setMockResponse(_ response: HTTPURLResponse?) {
        self.mockResponse = response
    }
    
    func setMockError(_ error: Error?) {
        self.mockError = error
    }
}
