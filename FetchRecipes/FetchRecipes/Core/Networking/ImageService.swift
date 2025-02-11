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
}

actor ImageService: ImageServiceProtocol {
    private var tasks : [URL: Task<Data, Error>]
    
    init(tasks: [URL : Task<Data, Error>] = [:]) {
        self.tasks = tasks
    }
    
    func fetchImageData(url: URL) async throws -> Data {
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

    private func cancelFetchAsync(url: URL) async {
        tasks[url]?.cancel()
        tasks[url] = nil
    }
    
    
}
