import Foundation
import UIKit

class RecipeData: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var folders: [Folder] = []
    @Published var tags: [Tag] = []
    
    private let recipesKey = "savedRecipes"
    private let imageCache = NSCache<NSString, UIImage>()
    
    init() {
        loadFolders()
        loadRecipes()
        loadTags()
    }
    
    func loadRecipes() {
        // Try to load from disk first
        if let diskRecipes = loadRecipesFromDisk() {
            self.recipes = diskRecipes
            self.recipes = self.recipes // Force UI update
            print("Loaded recipes: \(recipes.map { $0.id })")
            return
        }

        // Try to load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: recipesKey),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            self.recipes = decodedRecipes
            self.recipes = self.recipes // Force UI update
            print("Loaded recipes: \(recipes.map { $0.id })")
            return
        }

        // No recipes found, start with an empty array (do not load mock data)
        self.recipes = []
        self.recipes = self.recipes // Force UI update
        saveRecipes() // Save the empty state to disk
        print("Loaded recipes: []")
    }
    
    func saveRecipes() {
        if let encoded = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(encoded, forKey: recipesKey)
        }
        saveRecipesToDisk()
    }
    
    // Save recipes to device storage (Documents directory)
    private func saveRecipesToDisk() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return }
        let fileURL = documentsURL.appendingPathComponent("recipes.json")
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save recipes to disk: \(error)")
        }
    }

    // Load recipes from device storage (Documents directory)
    private func loadRecipesFromDisk() -> [Recipe]? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return nil }
        let fileURL = documentsURL.appendingPathComponent("recipes.json")
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Recipe].self, from: data)
            return decoded
        } catch {
            print("Failed to load recipes from disk: \(error)")
            return nil
        }
    }
    
    func loadFolders() {
        // Try to load from disk first
        if let diskFolders = loadFoldersFromDisk() {
            self.folders = diskFolders
            self.folders = self.folders // Force UI update
            print("Loaded folders: \(folders)")
            for folder in folders {
                print("Folder \(folder.name) contains: \(folder.recipes)")
            }
            return
        }
        
        // Load folders from UserDefaults or create default folders
        if let data = UserDefaults.standard.data(forKey: "folders"),
           let decodedFolders = try? JSONDecoder().decode([Folder].self, from: data) {
            self.folders = decodedFolders
            self.folders = self.folders // Force UI update
            print("Loaded folders: \(folders)")
            for folder in folders {
                print("Folder \(folder.name) contains: \(folder.recipes)")
            }
        } else {
            self.folders = Folder.sampleFolders
            self.folders = self.folders // Force UI update
            saveFolders()
            print("Loaded folders: \(folders)")
            for folder in folders {
                print("Folder \(folder.name) contains: \(folder.recipes)")
            }
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
        saveFoldersToDisk() // Ensure folders are always saved to disk
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
        folders = folders // Trigger SwiftUI update
        saveFolders() // Save folder changes to UserDefaults and disk
        saveRecipes() // Also save recipes to disk to ensure consistency
    }
    
    // Save folders to device storage (Documents directory)
    private func saveFoldersToDisk() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return }
        let fileURL = documentsURL.appendingPathComponent("folders.json")
        do {
            let data = try JSONEncoder().encode(folders)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save folders to disk: \(error)")
        }
    }

    // Load folders from device storage (Documents directory)
    private func loadFoldersFromDisk() -> [Folder]? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return nil }
        let fileURL = documentsURL.appendingPathComponent("folders.json")
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Folder].self, from: data)
            return decoded
        } catch {
            print("Failed to load folders from disk: \(error)")
            return nil
        }
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
    
    func addRecipe(_ recipe: Recipe, image: UIImage?) {
        var newRecipe = recipe
        
        // Save image if provided
        if let image = image {
            let imageName = "\(recipe.id).jpg"
            saveImage(image, withName: imageName)
            newRecipe.image = imageName
        }
        
        recipes.append(newRecipe)
        saveRecipes() // This will save to disk as well
    }
    
    private func saveImage(_ image: UIImage, withName name: String) {
        // Save to cache
        imageCache.setObject(image, forKey: name as NSString)
        
        // Save to documents directory
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(name)
        
        try? data.write(to: fileURL)
    }
    
    func loadImage(named name: String) -> UIImage? {
        // Check cache first
        if let cachedImage = imageCache.object(forKey: name as NSString) {
            return cachedImage
        }
        
        // Load from documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(name)
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        // Save to cache
        imageCache.setObject(image, forKey: name as NSString)
        return image
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        // Remove from recipes array
        recipes.removeAll { $0.id == recipe.id }
        // Remove from all folders
        for i in 0..<folders.count {
            folders[i].recipes.removeAll { $0 == recipe.id }
        }
        saveRecipes()
        saveFolders()
    }
}
