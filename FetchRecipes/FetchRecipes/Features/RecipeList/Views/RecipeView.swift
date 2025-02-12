//
//  RecipeView.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

struct RecipeView: View {
    @StateObject var viewModel: RecipeViewModel
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading && viewModel.recipes.isEmpty{
                    RecipeLoadingView()
                } else if viewModel.recipes.isEmpty {
                    EmptyRecipeView(viewModel: viewModel)
                } else if viewModel.sectionedRecipes.isEmpty{
                    NoResultsView()
                } else {
                    RecipeListView(viewModel: viewModel)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchRecipes()
                }
            }
            .navigationTitle("Recipes")
            .alert("Error Loading Recipes", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") { viewModel.error = nil }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "")
            }
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
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
                    await viewModel.fetchRecipes()
                }
            }
            .offset(y: -50)
        }
    }
}

struct NoResultsView: View {
    var body: some View {
        VStack {
            ContentUnavailableView("No Recipes Found",
                                   systemImage: "fork.knife.circle",
                                   description: Text("Refine your search and try again.")
            )
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
        List {
            ForEach(viewModel.sections, id: \.self) { cuisine in
                Section(header: Text(cuisine)) {
                    ForEach(viewModel.sectionedRecipes[cuisine] ?? []) { recipe in
                        RecipeCardView(
                            name: recipe.name,
                            cuisine: recipe.cuisine,
                            imageURL: recipe.photoUrlSmall
                        )
                    }
                }
            }
        }
        .refreshable {
            Task {
                await viewModel.fetchRecipes()
            }
        }
    }
}
