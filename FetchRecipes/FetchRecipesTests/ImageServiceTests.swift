//
//  ImageServiceTests.swift
//  FetchRecipesTests
//
//  Created by Joshua Scorca on 2/11/25.
//

import XCTest
@testable import FetchRecipes

final class ImageServiceTests: XCTestCase {
    
    var sut: ImageService!
    var mockClient: MockHTTPClient!
    var mockTasks: [URL : Task<Data, Error>] = [:]
    
    override func setUp() {
        mockClient = MockHTTPClient()
        sut = ImageService(client: mockClient)
    }
    
    override func tearDown() {
        mockClient = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchImageData_Success() async throws {
        // Given
        let testURL = URL(string: "https://mock.com")!
        let expectedData = "test image data".data(using: .utf8)!
        await mockClient.setMockData(expectedData)
        let mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        await mockClient.setMockResponse(mockResponse)
        
        // When
        let receivedData = try await sut.fetchImageData(url: testURL)
        
        // Then
        XCTAssertEqual(receivedData, expectedData)
    }
    
    func testFetchImageData_BadResponse() async {
        // Given
        let testURL = URL(string: "https://mock.com")!
        await mockClient.setMockData(Data())
        let mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        await mockClient.setMockResponse(mockResponse)
        
        // When/Then
        do {
            _ = try await sut.fetchImageData(url: testURL)
            XCTFail("Expected error but got success")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badServerResponse)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    func testFetchImageData_CachesTask() async throws {
        // Given
        let testURL = URL(string: "https://mock.com")!
        let expectedData = "test image data".data(using: .utf8)!
        await mockClient.setMockData(expectedData)
        let mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        await mockClient.setMockResponse(mockResponse)
        
        // When
        // Start two concurrent fetches for the same URL
        async let firstFetch = sut.fetchImageData(url: testURL)
        async let secondFetch = sut.fetchImageData(url: testURL)
        
        // Then
        let (data1, data2) = try await (firstFetch, secondFetch)
        XCTAssertEqual(data1, data2)
        // Verify that only one network request was made
        let count = await mockClient.getRequestCount()
        XCTAssertEqual(count, 1)
    }
    
    func testCancelFetch() async throws {
        // Given
        let testURL = URL(string: "https://mock.com")!
        await mockClient.setSimulateDelay(true)
        
        // When
        let fetchTask = Task {
            try await sut.fetchImageData(url: testURL)
        }
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        await sut.cancelFetch(url: testURL)
        
        // Then
        do {
            _ = try await fetchTask.value
            XCTFail("Expected cancellation")
        } catch is CancellationError {
            // Success - task was cancelled
        } catch {
            XCTFail("Expected cancellation error but got \(error)")
        }
    }
}
