//
//  ImageService.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

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
                throw URLError(.badServerResponse)
            }
            return data
        }
        
        do {
            let data = try await task.value
            tasks[url] = nil
            return data
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
