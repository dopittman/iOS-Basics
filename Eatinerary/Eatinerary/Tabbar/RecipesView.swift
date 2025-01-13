//
//  Recipes.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

struct RecipesView: View {
    var body: some View {
        
            VStack(alignment: .leading) {
                RecipeCardView(
                    recipeName: "Hamburger Helper",
                    timeText: "1h 45m",
                    difficultyText: "Hard",
                    isFavorite: true
                )
                RecipeCardView(
                    recipeName: "Hamburger Helper",
                    timeText: "1h 45m",
                    difficultyText: "Hard",
                    isFavorite: false
                )
                
        }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

    }
}

#Preview {
    RecipesView()
}
