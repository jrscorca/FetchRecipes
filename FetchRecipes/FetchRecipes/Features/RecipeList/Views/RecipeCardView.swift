//
//  RecipeCardView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import SwiftUI

struct RecipeCardView: View {
    let name: String
    let cuisine: String
    let imageURL: String?
    
    init(name: String, cuisine: String, imageURL: String?) {
        self.name = name
        self.cuisine = cuisine
        self.imageURL = imageURL
    }
    
    var body: some View {
        HStack {
            
            /*
            AsyncImage(url: URL(string: imageURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 128, height: 128)
            .clipShape(.rect(cornerRadius: 25))
             */
            
            AsyncImageView(imageViewModel: ImageViewModel(url: URL(string: imageURL ?? "")!))
                .frame(width: 128, height: 128)
                .clipShape(.rect(cornerRadius: 25))
            
            VStack {
                Text(name)
                Text(cuisine)
            }
            
            
        }
    }
}

#Preview {
    RecipeCardView(name: "mock name", cuisine: "mock cuisine", imageURL: nil)
}
