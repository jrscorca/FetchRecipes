//
//  RecipeViewModelTests.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/10/25.
//

import XCTest
@testable import FetchRecipes

@MainActor
class RecipeViewModelTests: XCTestCase {
    var sut: RecipeViewModel!
    var mockRepository: MockRecipeRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeRepository()
        sut = RecipeViewModel(recipeRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchRecipes_Success() async {
        // Given
        let mockRecipes = [
            Recipe(dto: RecipeDTO(uuid: "1", name: "Ravioli", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)),
            Recipe(dto: RecipeDTO(uuid: "2", name: "Sorbet", cuisine: "French", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil))
        ]
        
        await mockRepository.setMockRecipes(mockRecipes)
        
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertFalse(sut.recipes.isEmpty)
        XCTAssertEqual(sut.sections.count, 2)
        XCTAssertEqual(Set(sut.sections), Set(["Italian", "French"]))
    }
    
    func testFetchRecipes_Error() async {
        // Given
        await mockRepository.setMockError(URLError(.badServerResponse))
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertNotNil(sut.error)
    }
    
    func testFetchRecipes_Empty() async {
        // Given
        let mockRecipes: [Recipe] = []
        
        await mockRepository.setMockRecipes(mockRecipes)
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
    }
    
    func testSearchFilter_MatchesName() async {
        // Given
        let mockRecipes = [
            Recipe(dto: RecipeDTO(uuid: "1", name: "Ravioli", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)),
            Recipe(dto: RecipeDTO(uuid: "2", name: "Gelato", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil))
        ]
        await mockRepository.setMockRecipes(mockRecipes)
        await sut.fetchRecipes()
        
        // When
        sut.searchText = "Ravioli"
        
        // Then
        XCTAssertEqual(sut.sectionedRecipes["Italian"]?.count, 1)
        XCTAssertEqual(sut.sectionedRecipes["Italian"]?.first?.name, "Ravioli")
    }
    
    func testSearchFilter_MatchesCuisine() async {
        // Given
        let mockRecipes = [
            Recipe(dto: RecipeDTO(uuid: "1", name: "Ravioli", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)),
            Recipe(dto: RecipeDTO(uuid: "2", name: "Sorbet", cuisine: "French", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil))
        ]
        await mockRepository.setMockRecipes(mockRecipes)
        await sut.fetchRecipes()
        
        // When
        sut.searchText = "Ital"
        
        // Then
        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first, "Italian")
    }
    
    func testEmptySearchShowsAllRecipes() async {
        // Given
        let mockRecipes = [
            Recipe(dto: RecipeDTO(uuid: "1", name: "Ravioli", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)),
            Recipe(dto: RecipeDTO(uuid: "2", name: "Sorbet", cuisine: "French", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil))
        ]
        await mockRepository.setMockRecipes(mockRecipes)
        await sut.fetchRecipes()
        
        // When
        sut.searchText = ""
        
        // Then
        XCTAssertEqual(sut.sections.count, 2)
        XCTAssertEqual(sut.sectionedRecipes.values.reduce(0) { $0 + $1.count }, 2)
    }
    
    func testSearchNoMatchIsEmpty() async {
        // Given
        let mockRecipes = [
            Recipe(dto: RecipeDTO(uuid: "1", name: "Ravioli", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)),
            Recipe(dto: RecipeDTO(uuid: "2", name: "Sorbet", cuisine: "French", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil))
        ]
        await mockRepository.setMockRecipes(mockRecipes)
        await sut.fetchRecipes()
        
        // When
        sut.searchText = "American"
        
        // Then
        XCTAssertEqual(sut.sections.count, 0)
        XCTAssertEqual(sut.sectionedRecipes.values.reduce(0) { $0 + $1.count }, 0)
    }
}
