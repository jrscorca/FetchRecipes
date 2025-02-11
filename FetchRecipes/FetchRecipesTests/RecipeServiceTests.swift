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
    
    override func setUp() {
        super.setUp()
        sut = RecipeService()
    }
    
    func testFetchRecipes_Success() async throws {
        // Given
        let mockURL = RecipeEndpoint.fetchAllRecipes.url!
        
        // When
        let recipes = try await sut.fetchRecipes(endpoint: .fetchAllRecipes)
        
        // Then
        XCTAssertFalse(recipes.isEmpty)
        XCTAssertNotNil(recipes.first?.name)
        XCTAssertNotNil(recipes.first?.cuisine)
    }
    
    func testFetchRecipes_MalformedData() async {
        // Given
        let mockURL = RecipeEndpoint.integrationMalformed.url!
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes(endpoint: .integrationMalformed)
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testFetchRecipes_EmptyData() async throws {
        // Given
        let mockURL = RecipeEndpoint.integrationEmpty.url!
        
        // When
        let recipes = try await sut.fetchRecipes(endpoint: .integrationEmpty)
        
        // Then
        XCTAssertTrue(recipes.isEmpty)
    }
}
