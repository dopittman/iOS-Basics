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
    var difficultyColor: Color

    @State private var ratingState: Int = 0

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top){
                    
                    // Image Section
                    if let imageName = imageName {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .clipped()
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .clipped()
                    }
                    
                    // Recipe Title and stats
                    VStack(alignment: .leading) {
                        HStack{
                            Text(recipeName)
                                .fontWeight(.bold)
                                .lineLimit(2) // Restrict the text to one line
                                .truncationMode(.tail) // Truncate at the end with an ellipsis
                                .frame(width: 200) // Set a width for the text view to control truncation
                        }
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
                                if let difficultyRating = difficultyRating {
                                    ShowDifficultyRating(rating: .constant(difficultyRating))
                                } else {
                                    ShowDifficultyRating(rating: $ratingState)
                                }
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
                    Text(difficultyText)
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.white)
                        .background(
                            Capsule()
                                .fill(.black) // Fill the capsule with a color
                        )
                    

                    Text(difficultyText)
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.black)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.833, green: 0.868, blue: 0.759)) // Fill the capsule with a color
                        )
                    Text(difficultyText)
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.black)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.909, green: 0.743, blue: 0.685)) // Fill the capsule with a color
                        )
                    Text(difficultyText)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.black)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.67, green: 0.812, blue: 0.732)) // Fill the capsule with a color
                        )
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            



        }
        .padding()
        .background(Color(red: 0.986, green: 0.976, blue: 0.955))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
        .padding([.horizontal, .bottom])
    }
}

struct RecipeCardContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                RecipeCardView(
                    imageName: "heart.fill",
                    recipeName: "Spaghetti and meatballs",
                    timeText: "15 mins",
                    difficultyText: "Low",
                    isFavorite: true,
                    difficultyRating: 3,
                    difficultyColor: .green
                    
                )
                
                RecipeCardView(
                    recipeName: "Hamburger Helper",
                    timeText: "1h 45m",
                    difficultyText: "High",
                    isFavorite: false,
                    difficultyRating: 5,
                    difficultyColor: .red
                )
                RecipeCardView(
                    recipeName: "Hamburger Helper and cheese",
                    timeText: "1h 45m",
                    difficultyText: "High",
                    isFavorite: true,
                    difficultyRating: 5,
                    difficultyColor: .red
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
