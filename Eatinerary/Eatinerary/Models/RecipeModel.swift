//
//  RecipeModel.swift
//  Eatinerary
//
//  Created by David Pittman on 1/15/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    var id: UUID // Remove default value, must be decoded
    let name: String
    let prepTime: String
    let cookTime: String
    let ingredients: [Ingredient]
    let steps: [Step]  // Changed from [String] to [Step]
    let servings: String
    let notes: String
    let nutrition: [String]
    let tags: [String]
    let effortLevel: String
    var image: String?  // Changed from let to var
    let isFavorite: Bool
    
    // Nested class for ingredients
    class Ingredient: Codable {
        var item: String
        var quantity: Double
        var unit: String
        
        init(item: String, quantity: Double, unit: String) {
            self.item = item
            self.quantity = quantity
            self.unit = unit
        }
        
        enum CodingKeys: String, CodingKey {
            case item = "item"
            case quantity = "quantity"
            case unit = "unit"
        }
    }
    
    // Custom coding keys to match JSON structure
    enum CodingKeys: String, CodingKey {
        case id // Add id to coding keys
        case name = "Name"
        case prepTime = "PrepTime"
        case cookTime = "CookTime"
        case ingredients = "Ingredients"
        case steps = "Steps"
        case servings = "Servings"
        case notes = "Notes"
        case nutrition = "Nutrition"
        case tags = "Tags"
        case effortLevel = "Effort level"
        case image = "Image"
        case isFavorite
    }
    
    // Custom initializer to handle string array to Step conversion
    init(id: UUID = UUID(),
         name: String,
         prepTime: String,
         cookTime: String,
         ingredients: [Ingredient],
         steps: [String],  // Accept [String] but convert to [Step]
         servings: String,
         notes: String,
         nutrition: [String],
         tags: [String],
         effortLevel: String,
         image: String?,
         isFavorite: Bool) {
        self.id = id
        self.name = name
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.ingredients = ingredients
        self.steps = steps.enumerated().map { index, instruction in
            Step(number: index + 1, instruction: instruction)
        }
        self.servings = servings
        self.notes = notes
        self.nutrition = nutrition
        self.tags = tags
        self.effortLevel = effortLevel
        self.image = image
        self.isFavorite = isFavorite
    }
    
    // Custom decoder initializer to handle JSON decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Try to decode id, fallback to new UUID if not present
        id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        prepTime = try container.decode(String.self, forKey: .prepTime)
        cookTime = try container.decode(String.self, forKey: .cookTime)
        ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        // Flexible decoding for steps: try [Step] first, then fallback to [String]
        if let stepsArray = try? container.decode([Step].self, forKey: .steps) {
            steps = stepsArray
        } else if let stepStrings = try? container.decode([String].self, forKey: .steps) {
            steps = stepStrings.enumerated().map { index, instruction in
                Step(number: index + 1, instruction: instruction)
            }
        } else {
            steps = []
        }
        servings = try container.decode(String.self, forKey: .servings)
        notes = try container.decode(String.self, forKey: .notes)
        nutrition = try container.decode([String].self, forKey: .nutrition)
        tags = try container.decode([String].self, forKey: .tags)
        effortLevel = try container.decode(String.self, forKey: .effortLevel)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    // Computed properties
    var totalTime: String {
        return "\(prepTime) + \(cookTime)"
    }
    
    var imageNameOrDefault: String {
        return image ?? "DefaultRecipeImage"
    }
}

// Extension for mock data and preview helpers
extension Recipe {
    static var sampleRecipe: Recipe {
        Recipe(
            id: UUID(),
            name: "Spaghetti Carbonara",
            prepTime: "10 mins",
            cookTime: "20 mins",
            ingredients: [
                Ingredient(item: "spaghetti", quantity: 200, unit: "grams"),
                Ingredient(item: "Pancetta", quantity: 100, unit: "grams"),
                Ingredient(item: "Eggs", quantity: 2, unit: "large"),
                Ingredient(item: "Grated Parmesan", quantity: 50, unit: "grams"),
                Ingredient(item: "Garlic", quantity: 2, unit: "cloves")
            ],
            steps: [
                "Cook the spaghetti according to package instructions.",
                "In a pan, cook pancetta until crispy.",
                "Whisk eggs and Parmesan together in a bowl.",
                "Combine spaghetti, pancetta, and egg mixture, stirring quickly to coat the pasta.",
                "Season with salt and pepper and serve."
            ],
            servings: "2",
            notes: "Serve immediately for best taste.",
            nutrition: ["Calories: 400", "Protein: 18g", "Carbs: 50g", "Fat: 12g"],
            tags: ["Italian", "Quick", "Pasta"],
            effortLevel: "Easy",
            image: "TempSpaghetti",
            isFavorite: true
        )
    }
    
    static func loadFromJSON(named filename: String) -> Recipe? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not load JSON file")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Recipe.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

// Preview helpers
#if DEBUG
extension Recipe {
    static var mockRecipes: [Recipe] {
        [sampleRecipe]
    }
}
#endif
