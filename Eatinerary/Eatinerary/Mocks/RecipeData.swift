//
//  RecipeData.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import Foundation

class RecipeData: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    init() {
        loadRecipes()
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
}
