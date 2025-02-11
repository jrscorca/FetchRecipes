//
//  ImageViewModel.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

@MainActor
public final class ImageViewModel: ObservableObject {
    private let imageRepository: ImageRepository
    @Published public var image: UIImage?
    @Published public var error: Error?
    private let url : URL
    
    init(imageRepository: ImageRepository = DefaultImageRepository(imageService: ImageService()), url: URL) {
        self.imageRepository = imageRepository
        self.url = url
    }
    
    func fetchImage() async {
        error = nil
        do {
            image = try await imageRepository.get(from: url)
        } catch {
            self.error = error
        }
        
    }
    
    func cancelImageFetch() {
        imageRepository.cancelFetch(for: url)
    }
}
