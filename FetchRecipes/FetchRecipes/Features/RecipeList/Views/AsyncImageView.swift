//
//  AsyncImageView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
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
                ZStack{
                    Color.gray
                        .aspectRatio(contentMode: .fit)
                    Image(systemName: "fork.knife")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                }
            }
        }
        .onAppear {
            Task {
                await imageViewModel.fetchImage()
            }
        }
        .onDisappear {
            Task {
                await imageViewModel.cancelImageFetch()
            }
        }
    }
}

#Preview {
    AsyncImageView(imageViewModel: ImageViewModel(url: URL(string: "https://placehold.co/200")!))
}
