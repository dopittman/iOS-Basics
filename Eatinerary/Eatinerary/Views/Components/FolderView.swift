import SwiftUI

struct FolderView: View {
    let folder: Folder
    let recipes: [Recipe]
    @ObservedObject var recipeData: RecipeData
    @State private var isExpanded = true
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Folder Header
            HStack {
                Image(systemName: isExpanded ? "folder.fill" : "folder")
                    .foregroundColor(.blue)
                Text(folder.name)
                    .font(.headline)
                Spacer()
                Text("\(recipes.count) recipes")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .contextMenu {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete Folder", systemImage: "trash")
                }
            }
            
            // Recipes in folder
            if isExpanded {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: DetailedRecipeView(previewRecipe: recipe)) {
                        RecipeCardView(
                            imageName: recipe.imageNameOrDefault,
                            recipeName: recipe.name,
                            timeText: recipe.cookTime,
                            difficultyText: recipe.effortLevel,
                            isFavorite: recipe.isFavorite
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onDrag {
                        NSItemProvider(object: recipe.id.uuidString as NSString)
                    }
                }
            }
        }
        .padding(.horizontal)
        .alert("Delete Folder", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                recipeData.deleteFolder(folder)
            }
        } message: {
            Text("Are you sure you want to delete this folder? The recipes will be moved to the unassigned section.")
        }
    }
}

struct UnassignedRecipesView: View {
    let recipes: [Recipe]
    @ObservedObject var recipeData: RecipeData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Unassigned Recipes")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(recipes) { recipe in
                NavigationLink(destination: DetailedRecipeView(previewRecipe: recipe)) {
                    RecipeCardView(
                        imageName: recipe.imageNameOrDefault,
                        recipeName: recipe.name,
                        timeText: recipe.cookTime,
                        difficultyText: recipe.effortLevel,
                        isFavorite: recipe.isFavorite
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .onDrag {
                    NSItemProvider(object: recipe.id.uuidString as NSString)
                }
            }
        }
    }
}