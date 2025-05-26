import Foundation

class RecipeData: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var folders: [Folder] = []
    @Published var tags: [Tag] = []
    
    init() {
        loadRecipes()
        loadFolders()
        loadTags()
    }
    
    func loadRecipes() {
        guard let url = Bundle.main.url(forResource: "RecipeMock", withExtension: "json") else {
            print("Failed to locate JSON file.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedRecipes = try decoder.decode([Recipe].self, from: data)
            self.recipes = decodedRecipes
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func loadFolders() {
        // Load folders from UserDefaults or create default folders
        if let data = UserDefaults.standard.data(forKey: "folders"),
           let decodedFolders = try? JSONDecoder().decode([Folder].self, from: data) {
            self.folders = decodedFolders
        } else {
            self.folders = Folder.sampleFolders
            saveFolders()
        }
    }
    
    func loadTags() {
        // Load tags from UserDefaults or create default tags
        if let data = UserDefaults.standard.data(forKey: "tags"),
           let decodedTags = try? JSONDecoder().decode([Tag].self, from: data) {
            self.tags = decodedTags
        } else {
            self.tags = Tag.sampleTags
            saveTags()
        }
    }
    
    func saveFolders() {
        if let encoded = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encoded, forKey: "folders")
        }
    }
    
    func saveTags() {
        if let encoded = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(encoded, forKey: "tags")
        }
    }
    
    func createFolder(name: String) {
        let newFolder = Folder(name: name)
        folders.append(newFolder)
        saveFolders()
    }
    
    func deleteFolder(_ folder: Folder) {
        // Remove the folder
        folders.removeAll { $0.id == folder.id }
        
        // Note: We don't delete the recipes themselves, they just become unassigned
        // The recipes will automatically appear in the unassigned section
        saveFolders()
    }
    
    func moveRecipe(_ recipe: Recipe, to folder: Folder) {
        // Remove recipe from all folders first
        for i in 0..<folders.count {
            folders[i].recipes.removeAll { $0 == recipe.id }
        }
        
        // Add recipe to the target folder
        if let index = folders.firstIndex(where: { $0.id == folder.id }) {
            folders[index].recipes.append(recipe.id)
        }
        
        saveFolders()
    }
    
    func getRecipesInFolder(_ folder: Folder) -> [Recipe] {
        return recipes.filter { recipe in
            folder.recipes.contains(recipe.id)
        }
    }
    
    func getUnassignedRecipes() -> [Recipe] {
        let allAssignedRecipeIds = Set(folders.flatMap { $0.recipes })
        return recipes.filter { !allAssignedRecipeIds.contains($0.id) }
    }
    
    // Search functionality
    func searchRecipes(query: String, selectedTag: Tag?) -> [Recipe] {
        var filteredRecipes = recipes
        
        // Filter by tag if selected
        if let tag = selectedTag {
            filteredRecipes = filteredRecipes.filter { recipe in
                recipe.tags.contains(tag.name)
            }
        }
        
        // Filter by search query if not empty
        if !query.isEmpty {
            filteredRecipes = filteredRecipes.filter { recipe in
                recipe.name.lowercased().contains(query.lowercased())
            }
        }
        
        return filteredRecipes
    }
    
    // Tag management
    func addTag(_ tag: Tag) {
        if !tags.contains(where: { $0.name == tag.name }) {
            tags.append(tag)
            saveTags()
        }
    }
    
    func removeTag(_ tag: Tag) {
        tags.removeAll { $0.id == tag.id }
        saveTags()
    }
}
