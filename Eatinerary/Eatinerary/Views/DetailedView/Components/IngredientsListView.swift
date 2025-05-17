//
//  IngredientsView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import SwiftUI

import SwiftUI

struct IngredientListView: View {
    let ingredients: [Recipe.Ingredient]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(ingredients, id: \.item) { ingredient in
                HStack(spacing: 4) {
                    // Quantity and unit in one color
                    Text("\(ingredient.quantity.formatted()) \(ingredient.unit)")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                    
                    // Item name in a different color
                    Text(ingredient.item.capitalized)
                        .foregroundColor(.primary)
                        
                }
            }
        }
    }
}

// Preview provider for SwiftUI canvas
struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListView(ingredients: Recipe.sampleRecipe.ingredients)
    }
}
