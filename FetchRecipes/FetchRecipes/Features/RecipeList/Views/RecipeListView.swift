//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/8/25.
//

import SwiftUI

struct RecipeView: View {
    @StateObject var viewModel: RecipeViewModel
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading && viewModel.recipes.isEmpty{
                    RecipeLoadingView()
                } else if viewModel.recipes.isEmpty {
                    EmptyRecipeView(viewModel: viewModel)
                } else {
                    RecipeListView(viewModel: viewModel)
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchRecipes()
                    } catch {
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Recipes")
            .alert(isPresented: $showAlert) {
                .init(title: Text("Error"), message: Text("Failed to load recipes."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    RecipeView(viewModel: RecipeViewModel())
}

struct EmptyRecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        VStack {
            ContentUnavailableView("No Recipes Available",
                                   systemImage: "fork.knife.circle",
                                   description: Text("Check your internet connection and try again.")
            )
            Button("Retry") {
                Task {
                    try await viewModel.fetchRecipes()
                }
            }
            .offset(y: -50)
        }
    }
}

struct RecipeLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading Recipes...")
        }
    }
}

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        List(viewModel.recipes) { recipe in
            RecipeCardView(name: recipe.name, cuisine: recipe.cuisine, imageURL: recipe.photoUrlSmall)
        }
        .refreshable {
            Task {
                try await viewModel.fetchRecipes()
            }
        }
    }
}
