//
//  DetailedRecipeView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import SwiftUI

struct FolderAndTagSection: View {
    let recipeIndex: Int
    @EnvironmentObject var recipeData: RecipeData

    private var recipe: Recipe {
        recipeData.recipes[recipeIndex]
    }
    private var folderId: UUID? {
        recipeData.folders.first(where: { $0.recipes.contains(recipe.id) })?.id
    }
    @State private var selectedFolderId: UUID? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Folder Picker
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundColor(.blue)
                Text("Folder:")
                    .font(.headline)
                Spacer()
                Picker("Folder", selection: Binding<UUID?>(
                    get: { folderId },
                    set: { newFolderId in
                        if let newFolderId = newFolderId,
                           let folder = recipeData.folders.first(where: { $0.id == newFolderId }) {
                            recipeData.moveRecipe(recipe, to: folder)
                        }
                    }
                )) {
                    Text("Unassigned").tag(UUID?.none)
                    ForEach(recipeData.folders) { folder in
                        Text(folder.name).tag(Optional(folder.id))
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)

            // Tags Section
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.green)
                    Text("Tags:")
                        .font(.headline)
                    Spacer()
                }
                .padding(.bottom, 2)
                // Tag chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(recipe.tags, id: \.self) { tagName in
                            Text(tagName)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color("GreenAccent")))
                                .foregroundColor(.black)
                        }
                        // Add Tag Button
                        Menu {
                            ForEach(recipeData.tags.filter { !recipe.tags.contains($0.name) }) { tag in
                                Button(tag.name) {
                                    var updatedRecipe = recipe
                                    updatedRecipe.tags.append(tag.name)
                                    recipeData.recipes[recipeIndex] = updatedRecipe
                                    recipeData.saveRecipes()
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
}

struct IngredientsAndStepsSection: View {
    let previewRecipe: Recipe

    var body: some View {
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

struct DetailedRecipeView: View {
    let previewRecipe: Recipe
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var recipeData: RecipeData
    @State private var showingDeleteAlert = false
    @State private var loadedUIImage: UIImage? = nil

    var recipeIndex: Int? {
        recipeData.recipes.firstIndex(where: { $0.id == previewRecipe.id })
    }

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
                                // Folder and Tag Section
                if let idx = recipeIndex {
                    FolderAndTagSection(recipeIndex: idx)
                        .environmentObject(recipeData)
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
                // Ingredients and Steps Section
                IngredientsAndStepsSection(previewRecipe: previewRecipe)
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
