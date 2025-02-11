//
//  DefaultImageRepository.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

enum ImageRepositoryError: Error {
    case saveToCacheFailed
    case loadFromCacheFailed
}

actor DefaultImageRepository: ImageRepository {
    
    let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func get(from url: URL) async throws -> UIImage? {
        if let imageData = try loadImageFromCache(url: url) {
            return UIImage(data: imageData)
        }
        
        let data = try await imageService.fetchImageData(url: url)
        try saveImageToCache(data: data, url: url)
        
        return UIImage(data: data)
    }
    
    nonisolated func cancelFetch(for url: URL) {
        Task {
            await self.cancelFetchAsync(url: url)
        }
    }

    private func cancelFetchAsync(url: URL) async {
        imageService.cancelFetch(url: url)
    }
    
    private func saveImageToCache(data: Data, url: URL) throws {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw ImageRepositoryError.saveToCacheFailed
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(url.absoluteString.hash.description)
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try data.write(to: fileURL)
        } catch {
            throw ImageRepositoryError.saveToCacheFailed
        }
    }
    
    private func loadImageFromCache(url: URL) throws -> Data? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("directory does not exist")
            throw ImageRepositoryError.loadFromCacheFailed
        }
        let fileURL = cacheDirectory.appendingPathComponent(url.absoluteString.hash.description)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw ImageRepositoryError.loadFromCacheFailed
            }
        }
        return nil
    }
    
}
