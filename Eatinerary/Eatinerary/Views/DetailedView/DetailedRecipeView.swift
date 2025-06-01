//
//  DetailedRecipeView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import SwiftUI

struct DetailedRecipeView: View {
    let previewRecipe: Recipe
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var recipeData: RecipeData
    @State private var showingDeleteAlert = false
    @State private var loadedUIImage: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack {
                // Header
                ZStack(alignment: .topLeading) {
                    let imageName = previewRecipe.imageNameOrDefault
                    if imageName != "DefaultRecipeImage" {
                        if let loadedUIImage = loadedUIImage {
                            Image(uiImage: loadedUIImage)
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.9
                                }
                                .aspectRatio(contentMode: .fill)
                                .overlay(
                                    Color.black.opacity(0.4)
                                )
                                .frame(height: 160)
                                .cornerRadius(15)
                                .clipped()
                        } else if imageName.hasSuffix(".jpg") {
                            Image("DefaultRecipeImage")
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.9
                                }
                                .aspectRatio(contentMode: .fill)
                                .overlay(
                                    Color.black.opacity(0.4)
                                )
                                .frame(height: 160)
                                .cornerRadius(15)
                                .clipped()
                        } else {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.9
                                }
                                .aspectRatio(contentMode: .fill)
                                .overlay(
                                    Color.black.opacity(0.4)
                                )
                                .frame(height: 160)
                                .cornerRadius(15)
                                .clipped()
                        }
                    }
                    
                    Text(previewRecipe.name)
                        .foregroundColor(previewRecipe.imageNameOrDefault == "DefaultRecipeImage" ? .black : .white)
                        .font(.title)
                        .fontWeight(.bold)
                        .shadow(radius: 1)
                        .padding(15)
                }
                
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.componentAuto)
                        .frame(height: 60)
                        .overlay(
                            VStack(alignment: .leading) {
                                HStack(spacing: 4) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color.textAuto)
                                        .frame(width: 20, alignment: .leading)
                                    Text("Serving Size: ")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                    Text(previewRecipe.servings)
                                        .foregroundColor(.black)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(Color.textAuto)
                                        .frame(width: 20, alignment: .leading)
                                    
                                    Text("Prep:")
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.bold)
                                    Text(previewRecipe.prepTime)
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.semibold)
                                    Text("|")
                                        .fontWeight(.semibold)
                                    Text("Cook:")
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.bold)
                                    Text(previewRecipe.cookTime)
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        )
                }
                .padding(.top, 12)
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Ingredients")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                        IngredientListView(ingredients: previewRecipe.ingredients)
                            .padding()
                    }
                    
                    HStack {
                        Text("Steps")
                            .fontWeight(.bold)
                         Spacer()
                    }
                    .padding(.bottom, 4)
                    .padding(.top, 12)
                    
                    StepsListView(steps: previewRecipe.steps)
                }
                .padding(.top, 12)
                .padding(.horizontal)
            }
        }
        .background(Color.appBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                recipeData.deleteRecipe(previewRecipe)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
        .onAppear {
            let imageName = previewRecipe.imageNameOrDefault
            if imageName != "DefaultRecipeImage" && imageName.hasSuffix(".jpg") {
                if let uiImage = recipeData.loadImage(named: imageName) {
                    loadedUIImage = uiImage
                }
            }
        }
    }
}

#Preview {
    DetailedRecipeView(previewRecipe: Recipe.sampleRecipe)
}
