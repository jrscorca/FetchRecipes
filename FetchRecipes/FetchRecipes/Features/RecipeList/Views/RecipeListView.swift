//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import SwiftUI

struct InfiniteScrollView<Content: View>: View {
    let recipes: [Recipe]
    var content: (Recipe) -> Content
    var body: some View {
        List(recipes) {  item in
            content(item)
                .onAppear {
                    
                }
        }.refreshable {
            
        }
    }
}

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    
    var body: some View {
        InfiniteScrollView(recipes: viewModel.recipes) { recipe in
            RecipeCardView(name: recipe.name, cuisine: recipe.cuisine, imageURL: recipe.photoUrlSmall)
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchRecipes()
                } catch {
                    #warning("Handle error by showing alert")
                }
            }
            
        }
    }
}

#Preview {
    RecipeListView(viewModel: RecipeListViewModel())
}
