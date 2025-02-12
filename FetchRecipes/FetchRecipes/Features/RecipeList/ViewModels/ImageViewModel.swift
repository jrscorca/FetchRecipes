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
    private let url : URL
    @Published var image: UIImage?
    @Published var error: Error?
    
    init(imageRepository: ImageRepository = DefaultImageRepository(), url: URL) {
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
    
    func cancelImageFetch() async {
        await imageRepository.cancelFetch(for: url)
        
    }
}
