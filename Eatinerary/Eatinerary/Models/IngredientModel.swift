//
//  IngredientModel.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    let item: String
    let quantity: Double
    let unit: String
    
    // Custom initializer with automatic ID generation
    init(item: String, quantity: Double, unit: String, id: UUID = UUID()) {
        self.id = id
        self.item = item
        self.quantity = quantity
        self.unit = unit
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable conformance
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    // Helper method to format the measurement
    func formattedMeasurement() -> String {
        return "\(quantity) \(unit)"
    }
}

// Extension for sample data and helper methods
extension Ingredient {
    static var sampleIngredients: [Ingredient] = [
        Ingredient(item: "spaghetti", quantity: 200, unit: "g"),
        Ingredient(item: "pancetta", quantity: 100, unit: "g"),
        Ingredient(item: "eggs", quantity: 2, unit: "large"),
        Ingredient(item: "parmesan", quantity: 50, unit: "g"),
        Ingredient(item: "garlic", quantity: 2, unit: "cloves")
    ]
}
