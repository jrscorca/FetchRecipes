//
//  ImageService.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import Foundation

actor ImageService: ImageServiceProtocol {
    private let client: HTTPClient
    private var tasks : [URL: Task<Data, Error>]
    
    init(client: HTTPClient = URLSessionHTTPClient(), tasks: [URL : Task<Data, Error>] = [:]) {
        self.tasks = tasks
        self.client = client
    }
    
    func fetchImageData(url: URL) async throws -> Data {
        if let task = tasks[url] {
            return try await task.value
        }
        
        let task = Task<Data, Error> {
            let (data, response) = try await client.getData(for: URLRequest(url: url))
            try Task.checkCancellation()
            guard (200...299).contains(response.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return data
        }
        
        tasks[url] = task
        
        do {
            let data = try await task.value
            tasks[url] = nil
            return data
        }
    }
    
    func cancelFetch(url: URL) async {
        await self.cancelFetchAsync(url: url)
    }

    private func cancelFetchAsync(url: URL) async {
        tasks[url]?.cancel()
        tasks[url] = nil
    }
    
}
