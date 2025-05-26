import Foundation

struct Folder: Identifiable, Codable {
    let id: UUID
    var name: String
    var recipes: [UUID] // Array of recipe IDs in this folder
    
    init(id: UUID = UUID(), name: String, recipes: [UUID] = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
}

// Extension for sample data
extension Folder {
    static var sampleFolders: [Folder] = [
        Folder(name: "Breakfast"),
        Folder(name: "Dinner"),
        Folder(name: "Desserts")
    ]
} 