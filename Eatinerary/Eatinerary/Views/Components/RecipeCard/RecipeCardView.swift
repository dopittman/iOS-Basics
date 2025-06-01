//
//  RecipeCardView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

struct RecipeCardView: View {
    var imageName: String?
    var recipeName: String
    var timeText: String
    var difficultyText: String
    var isFavorite: Bool
    var difficultyRating: Int?
    var recipeData: RecipeData? = nil // Optional, for loading user images

    @State private var loadedUIImage: UIImage? = nil
    @State private var ratingState: Int = 0

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top){
                    // Image Section
                    if let imageName = imageName, imageName != "DefaultRecipeImage" {
                        if let loadedUIImage = loadedUIImage {
                            Image(uiImage: loadedUIImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80, alignment: .center)
                                .cornerRadius(10)
                                .clipped()
                                .padding(.trailing, 4)
                                .padding(.bottom, 4)
                        } else if imageName.hasSuffix(".jpg") {
                            // User image not found, show default
                            Image("DefaultRecipeImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80, alignment: .center)
                                .cornerRadius(10)
                                .clipped()
                                .padding(.trailing, 4)
                                .padding(.bottom, 4)
                        } else {
                            // Asset image fallback
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80, alignment: .center)
                                .cornerRadius(10)
                                .clipped()
                                .padding(.trailing, 4)
                                .padding(.bottom, 4)
                        }
                    }
                        
                    // Recipe Title and stats
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(){
                            Text(recipeName)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2) // Restrict the text to one line
                                .truncationMode(.tail) // Truncate at the end with an ellipsis
                                .padding(.trailing, 40) // Add padding to avoid overlapping the heart
                        }
                        .padding(.bottom, 4.0)



                        HStack(spacing: 4.0) {
                            
                            // Time Section
                            Image(systemName: "clock.fill")
                            Text(timeText)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("|")
                            
                            // Difficulty Section
                            HStack( spacing: 4.0){
                                Image(systemName: "bolt.fill")
                                ShowDifficultyRating(rating: .constant(difficultyRating ?? 0)) // Default to 0 if nil

                            }
                        }
                    }
       
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    // Conditionally show the heart icon
                    Group {
                        if isFavorite {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(hue: 0.045, saturation: 0.763, brightness: 0.935))
                                .frame(width: 20.0, height: 20.0)
                        }
                    },
                    alignment: .topTrailing // Position at the top right
                )
                HStack(alignment: .center){
                    Image(systemName: "tag.fill")
                    Text("Vegetarian")
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.black)
                        .background(
                            Capsule()
                                .fill(Color("GreenAccent")) // Fill the capsule with a color
                        )
                    

                    Text("Dinner")
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.black)
                        .background(
                            Capsule()
                                .fill(Color("GreenAccent")) // Fill the capsule with a color
                        )
                    Text("Healthy")
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.black)
                        .background(
                            Capsule()
                                .fill(Color("GreenAccent")) // Fill the capsule with a color
                        )

                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            



        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
        .padding([.horizontal, .bottom])
        .onAppear {
            if let imageName = imageName, imageName != "DefaultRecipeImage", let recipeData = recipeData {
                if let uiImage = recipeData.loadImage(named: imageName) {
                    loadedUIImage = uiImage
                }
            }
        }
    }
}

struct RecipeCardContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                RecipeCardView(
                    imageName: "TempSpaghetti",
                    recipeName: "Spaghetti and meatballs",
                    timeText: "15 mins",
                    difficultyText: "Low",
                    isFavorite: true,
                    difficultyRating: 1
                )
                
                RecipeCardView(
                    imageName: "TempHH2",
                    recipeName: "Hamburger Helper",
                    timeText: "1h 15m",
                    difficultyText: "High",
                    isFavorite: false,
                    difficultyRating: 3
                )
                RecipeCardView(
                    imageName: "TempHamburgerHelper",
                    recipeName: "Hamburger Helper and cheese",
                    timeText: "1h 45m",
                    difficultyText: "High",
                    isFavorite: true,
                    difficultyRating: 5
                )
                RecipeCardView(
                    recipeName: "Hamburger Helper and cheese",
                    timeText: "1h 45m",
                    difficultyText: "High",
                    isFavorite: true,
                    difficultyRating: 2
                )
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardContentView()
    }
}
