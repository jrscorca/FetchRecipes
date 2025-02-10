//
//  ImageService.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

enum ImageServiceError : Error {
    case badServerResponse
    case requestFailed
    case saveToCacheFailed
    case loadFromCacheFailed
}

actor ImageService: ImageServiceProtocol {
    private var tasks : [URL: Task<Data, Error>]
    
    init(tasks: [URL : Task<Data, Error>] = [:]) {
        self.tasks = tasks
    }
    
    func fetchImageData(url: URL) async throws -> Data {
        if let imageData = try loadImageFromCache(url: url) {
            return imageData
        }
        
        if let task = tasks[url] {
            return try await task.value
        }
        
        let task = Task<Data, Error> {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            try Task.checkCancellation()
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                throw ImageServiceError.badServerResponse
            }
            return data
        }
        
        do {
            let data = try await task.value
            try saveImageToCache(data: data, url: url)
            tasks[url] = nil
            return data
        } catch let error as ImageServiceError {
            tasks[url] = nil
            throw error
        }
        
    }
    
    nonisolated func cancelFetch(url: URL) {
        Task {
            await self.cancelFetchAsync(url: url)
        }
    }
    
    private func saveImageToCache(data: Data, url: URL) throws {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw ImageServiceError.saveToCacheFailed
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(url.absoluteString.hash.description)
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try data.write(to: fileURL)
        } catch {
            throw ImageServiceError.saveToCacheFailed
        }
    }
    
    private func loadImageFromCache(url: URL) throws -> Data? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("directory does not exist")
            throw ImageServiceError.loadFromCacheFailed
        }
        let fileURL = cacheDirectory.appendingPathComponent(url.absoluteString.hash.description)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw ImageServiceError.loadFromCacheFailed
            }
        }
        return nil
    }
    
    private func cancelFetchAsync(url: URL) async {
        tasks[url]?.cancel()
        tasks[url] = nil
    }
    
    
}
