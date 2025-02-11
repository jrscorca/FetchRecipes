//
//  RecipeDetailView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            // Larger image
            if let url = recipe.photoUrlLarge {
                AsyncImageView(imageViewModel: ImageViewModel(url: url))
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(recipe.cuisine)
                        .font(.headline)
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    if let url = recipe.sourceUrl {
                        Link(destination: url) {
                            VStack {
                                Image(systemName: "book.fill")
                                Text("Recipe")
                            }
                        }
                    }
                    
                    if let url = recipe.youtubeUrl {
                        Link(destination: url) {
                            VStack {
                                Image(systemName: "play.circle.fill")
                                Text("Video")
                            }
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(recipe.name)
    }
}

#Preview {
    RecipeDetailView(recipe: .init(dto: RecipeDTO(uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                                                  name: "Banana Pancakes",
                                                  cuisine: "American",
                                                  photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
                                                  photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
                                                  sourceUrl: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
                                                  youtubeUrl: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"))
    )
    
}
