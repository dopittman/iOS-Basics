//
//  Recipes.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct RecipesView: View {
    @StateObject private var recipeData = RecipeData()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(recipeData.recipes) { recipe in
                        NavigationLink(destination: DetailedRecipeView(previewRecipe: recipe)) {
                            RecipeCardView(
                                imageName: recipe.imageNameOrDefault,
                                recipeName: recipe.name,
                                timeText: recipe.cookTime,
                                difficultyText: recipe.effortLevel,
                                isFavorite: recipe.isFavorite
                            )
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes NavigationLink styling
                    }
                }
                .padding()
            }
            .navigationTitle("Recipes")
        }
        .onAppear {
            recipeData.loadRecipes()
        }
    }
}

#Preview {
    RecipesView()
}
#Preview {
    RecipesView()
}
