//
//  RecipeServiceTests.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/10/25.
//

import XCTest
@testable import FetchRecipes

final class RecipeServiceTests: XCTestCase {
    var sut: RecipeService!
        var mockClient: MockHTTPClient!
        
        override func setUp() {
            mockClient = MockHTTPClient()
            sut = RecipeService(client: mockClient)
        }
        
        func testFetchRecipes_Success() async throws {
            // Given
            let mockData = """
            {
                "recipes": [
                    {
                        "uuid": "1",
                        "name": "Pizza",
                        "cuisine": "Italian"
                    }
                ]
            }
            """.data(using: .utf8)!
            
            await mockClient.setMockData(mockData)
            
            let mockHttpResponse = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            await mockClient.setMockResponse(mockHttpResponse)
            
            // When
            let recipes = try await sut.fetchRecipes()
            
            // Then
            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(recipes[0].name, "Pizza")
        }
        
        func testFetchRecipes_BadResponse() async {
            // Given
            await mockClient.setMockData(Data())
            
            let mockHttpResponse = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )
            await mockClient.setMockResponse(mockHttpResponse)
            
            // When/Then
            do {
                _ = try await sut.fetchRecipes()
                XCTFail("Expected error but got success")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)
            } catch {
                XCTFail("Unexpected Error")
            }
        }

}
