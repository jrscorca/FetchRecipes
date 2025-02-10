//
//  RecipeCardView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
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
        HStack(spacing:22) {
            if let imageURL, let url = URL(string: imageURL ) {
                AsyncImageView(imageViewModel: ImageViewModel(url: url))
                    .frame(width: 128, height: 128)
                    .clipShape(.rect(cornerRadius: 25))
            } else {
                Color.gray
                    .frame(width: 128, height: 128)
                    .clipShape(.rect(cornerRadius: 25))
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.headline)
                    .minimumScaleFactor(0.1)
                    .lineLimit(2)
                
                Text(cuisine)
                    .font(.subheadline)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            Spacer()
        }
        //.padding(.horizontal)
    }
}

#Preview {
    RecipeCardView(name: "mock name", cuisine: "mock cuisine", imageURL: nil)
}
