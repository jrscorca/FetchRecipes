//
//  AsyncImageView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/9/25.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject var imageViewModel: ImageViewModel
    var body: some View {
        Group {
            if let image = imageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Color.gray
                .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            Task {
                do {
                    try await imageViewModel.fetchImage()
                } catch {
                    #warning("Handle error by showing alert")
                }
            }
        }
        .onDisappear {
            imageViewModel.cancelImageFetch()
            
        }
    }
}

#Preview {
    AsyncImageView(imageViewModel: ImageViewModel(url: URL(string: "https://placehold.co/200")!))
}
