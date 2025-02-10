//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/10/25.
//

import XCTest
@testable import FetchRecipes

final class FetchRecipesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRecipeService() async throws {
        let service = RecipeService()
        do {
            let recipes = try await service.fetchRecipes()
            XCTAssert(!recipes.isEmpty)
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
        
    }
    
    func testRecipeServiceMalformed() async throws {
        let service = RecipeService()
        do {
            let _ = try await service.fetchRecipes(endpoint: .integrationMalformed)
            XCTFail("Expected this malformed endpoint to fail")
        } catch {
            print(error.localizedDescription)
            XCTAssertTrue(error is NetworkError)
        }
    }
        
    
    func testRecipeServiceEmpty() async throws {
        let service = RecipeService()
        do {
            let recipes = try await service.fetchRecipes(endpoint: .integrationEmpty)
            XCTAssert(recipes.isEmpty)
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
        
    }
    
}
