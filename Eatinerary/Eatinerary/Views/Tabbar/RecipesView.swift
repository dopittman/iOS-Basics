import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var recipeData: RecipeData
    @State private var showingNewFolderSheet = false
    @State private var showingNewRecipeSheet = false
    @State private var newFolderName = ""
    @State private var searchText = ""
    @State private var selectedTag: Tag?
    
    var filteredRecipes: [Recipe] {
        recipeData.searchRecipes(query: searchText, selectedTag: selectedTag)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBarView(
                    searchText: $searchText,
                    selectedTag: $selectedTag,
                    allTags: recipeData.tags,
                    onTagSelected: { _ in }
                )
                .padding(.vertical, 8)
                
                // Content
                ScrollView {
                    if searchText.isEmpty && selectedTag == nil {
                        // Normal folder view
                        VStack(alignment: .leading, spacing: 16) {
                            // Folders Section
                            ForEach(recipeData.folders) { folder in
                                FolderView(
                                    folder: folder,
                                    recipes: recipeData.getRecipesInFolder(folder),
                                    recipeData: recipeData
                                )
                                .onDrop(of: [.text], delegate: FolderDropDelegate(folder: folder, recipeData: recipeData))
                            }
                            
                            // Unassigned Recipes Section
                            UnassignedRecipesView(
                                recipes: recipeData.getUnassignedRecipes(),
                                recipeData: recipeData
                            )
                        }
                        .padding(.vertical)
                    } else {
                        // Search results
                        VStack(alignment: .leading, spacing: 16) {
                            if let selectedTag = selectedTag {
                                Text("Showing results for tag: \(selectedTag.name)")
                                    .font(.headline)
                                    .padding(.horizontal)
                            }
                            
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(destination: DetailedRecipeView(previewRecipe: recipe).environmentObject(recipeData)) {
                                    RecipeCardView(
                                        imageName: recipe.imageNameOrDefault,
                                        recipeName: recipe.name,
                                        timeText: recipe.cookTime,
                                        difficultyText: recipe.effortLevel,
                                        isFavorite: recipe.isFavorite,
                                        tags: recipe.tags, // <-- pass tags
                                        recipeData: recipeData // Pass for user images
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: { showingNewRecipeSheet = true }) {
                            Image(systemName: "plus")
                        }
                        Button(action: { showingNewFolderSheet = true }) {
                            Image(systemName: "folder.badge.plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingNewFolderSheet) {
                NavigationStack {
                    Form {
                        TextField("Folder Name", text: $newFolderName)
                    }
                    .navigationTitle("New Folder")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showingNewFolderSheet = false
                            newFolderName = ""
                        },
                        trailing: Button("Create") {
                            if !newFolderName.isEmpty {
                                recipeData.createFolder(name: newFolderName)
                                showingNewFolderSheet = false
                                newFolderName = ""
                            }
                        }
                    )
                }
            }
            .sheet(isPresented: $showingNewRecipeSheet) {
                AddRecipeView(recipeData: recipeData)
            }
        }
    }
}

struct FolderDropDelegate: DropDelegate {
    let folder: Folder
    let recipeData: RecipeData
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else { return false }
        
        itemProvider.loadObject(ofClass: NSString.self) { string, _ in
            if let recipeId = string as? String,
               let uuid = UUID(uuidString: recipeId),
               let recipe = recipeData.recipes.first(where: { $0.id == uuid }) {
                DispatchQueue.main.async {
                    recipeData.moveRecipe(recipe, to: folder)
                }
            }
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Optional: Add visual feedback when dragging over a folder
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

#Preview {
    RecipesView()
        .environmentObject(RecipeData())
}