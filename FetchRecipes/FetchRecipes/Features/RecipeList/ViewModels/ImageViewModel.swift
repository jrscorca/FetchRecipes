//
//  ImageViewModel.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

@MainActor
public final class ImageViewModel: ObservableObject {
    nonisolated private let imageService: ImageServiceProtocol
    @Published public var image: UIImage?
    @Published public var error: Error?
    private let url : URL
    
    init(imageService: ImageServiceProtocol = ImageService(), url: URL) {
        self.imageService = imageService
        self.url = url
    }
    
    func fetchImage() async {
        error = nil
        do {
            let data = try await imageService.fetchImageData(url: url)
            image = UIImage(data: data)
        } catch {
            self.error = error
        }
        
    }
    
    func cancelImageFetch() {
        imageService.cancelFetch(url: url)
    }
    
}
