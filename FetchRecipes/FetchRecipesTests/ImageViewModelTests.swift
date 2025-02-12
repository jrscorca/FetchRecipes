//
//  ImageViewModelTests.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/11/25.
//

import XCTest
@testable import FetchRecipes

@MainActor
final class ImageViewModelTests: XCTestCase {
    
    var mockRepository: MockImageRepository!
    var sut: ImageViewModel!
    let testURL = URL(string: "https://mock.com")!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockImageRepository()
        sut = ImageViewModel(imageRepository: mockRepository, url: testURL)
    }
    
    func testFetchImage_FromNetwork_Success() async throws {
        // Given
        let testImage = UIImage(systemName: "star")!
        let imageData = testImage.pngData()!
        await mockRepository.setMockImageData(imageData, for: testURL)
        
        // When
        await sut.fetchImage()
        
        // Then
        XCTAssertNotNil(sut.image)
        XCTAssertNil(sut.error)
    }
    
    func testFetchImage_FromCache_Success() async throws {
        // Given
        let testImage = UIImage(systemName: "star")!
        let imageData = testImage.pngData()!
        await mockRepository.setCachedData(imageData, for: testURL)
        
        // When
        await sut.fetchImage()
        
        // Then
        XCTAssertNotNil(sut.image)
        XCTAssertNil(sut.error)
    }
    
    func testCancelImageFetch() async {
        // When
        await sut.cancelImageFetch()  
        
        // Then
        let cancelledURLs = await mockRepository.cancelledURLs
        XCTAssertTrue(cancelledURLs.contains(testURL))
    }
    
}
