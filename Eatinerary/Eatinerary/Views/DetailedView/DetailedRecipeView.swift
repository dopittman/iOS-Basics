//
//  DetailedRecipeView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import SwiftUI

struct DetailedRecipeView: View {
    let previewRecipe: Recipe

    var body: some View {
        ScrollView {
            VStack {
                // Header
                ZStack(alignment: .topLeading) {
                    Image(previewRecipe.imageNameOrDefault)
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.9
                        }
                        .aspectRatio(contentMode: .fill)
                        .overlay(
                            Color.black.opacity(0.4)
                        )
                        .frame(height: 160)
                        .cornerRadius(15)
                        .clipped()
                    
                    Text(previewRecipe.name)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .shadow(radius: 2)
                        .padding(25)
                }
                
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.componentAuto)
                        .frame(height: 60)
                        .overlay(
                            VStack(alignment: .leading) {
                                HStack(spacing: 4) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color.textAuto)
                                        .frame(width: 20, alignment: .leading)
                                    Text("Serving Size: ")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                    Text(previewRecipe.servings)
                                        .foregroundColor(.black)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(Color.textAuto)
                                        .frame(width: 20, alignment: .leading)
                                    
                                    Text("Prep:")
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.bold)
                                    Text(previewRecipe.prepTime)
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.semibold)
                                    Text("|")
                                        .fontWeight(.semibold)
                                    Text("Cook:")
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.bold)
                                    Text(previewRecipe.cookTime)
                                        .foregroundColor(Color.textAuto)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        )
                }
                .padding(.top, 12)
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Ingredients")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                        IngredientListView(ingredients: previewRecipe.ingredients)
                            .padding()
                    }
                    
                    HStack {
                        Text("Steps")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    .padding(.top, 12)
                    
                    StepsListView(steps: previewRecipe.steps)
                }
                .padding(.top, 12)
                .padding(.horizontal)
            }
        }
        .background(Color.appBackground)
    }
}

#Preview {
    DetailedRecipeView(previewRecipe: Recipe.sampleRecipe)
}
