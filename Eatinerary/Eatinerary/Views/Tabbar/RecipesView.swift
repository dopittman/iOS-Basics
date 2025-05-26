import SwiftUI

struct RecipesView: View {
    @StateObject private var recipeData = RecipeData()
    @State private var showingNewFolderSheet = false
    @State private var newFolderName = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewFolderSheet = true }) {
                        Image(systemName: "folder.badge.plus")
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
        }
        .onAppear {
            recipeData.loadRecipes()
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
}