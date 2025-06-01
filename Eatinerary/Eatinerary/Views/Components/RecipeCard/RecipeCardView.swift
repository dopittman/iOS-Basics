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
    var tags: [String] = [] // <-- Add tags property
    var recipeData: RecipeData? = nil // Optional, for loading user images

    @State private var loadedUIImage: UIImage? = nil
    @State private var ratingState: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Image Section
                if let imageName = imageName, imageName != "DefaultRecipeImage" {
                    if let loadedUIImage = loadedUIImage {
                        Image(uiImage: loadedUIImage)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 2)
                    } else if imageName.hasSuffix(".jpg") {
                        Image("DefaultRecipeImage")
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 2)
                    } else {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 2)
                    }
                }
                // Main Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        Text(recipeName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Spacer()
                        if isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(hue: 0.045, saturation: 0.763, brightness: 0.935))
                                .font(.system(size: 18, weight: .bold))
                                .padding(.top, 2)
                        }
                    }
                    HStack(spacing: 10) {
                        Label(timeText, systemImage: "clock")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        Divider().frame(height: 16)
                        Label(difficultyText, systemImage: "bolt.fill")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        if let rating = difficultyRating, rating > 0 {
                            ShowDifficultyRating(rating: .constant(rating))
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            // Tag chips row
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule()
                                        .fill(Color("GreenAccent").opacity(0.18))
                                )
                                .foregroundColor(Color("GreenAccent"))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .transition(.opacity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color("CardBackground"))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
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
                    difficultyRating: 1,
                    tags: ["Italian", "Quick", "Pasta"]
                )
                
                RecipeCardView(
                    imageName: "TempHH2",
                    recipeName: "Hamburger Helper",
                    timeText: "1h 15m",
                    difficultyText: "High",
                    isFavorite: false,
                    difficultyRating: 3,
                    tags: ["Dinner", "Comfort Food"]
                )
                RecipeCardView(
                    imageName: "TempHamburgerHelper",
                    recipeName: "Hamburger Helper and cheese",
                    timeText: "1h 45m",
                    difficultyText: "High",
                    isFavorite: true,
                    difficultyRating: 5,
                    tags: ["Dinner", "Cheesy"]
                )
                RecipeCardView(
                    recipeName: "Hamburger Helper and cheese",
                    timeText: "1h 45m",
                    difficultyText: "High",
                    isFavorite: true,
                    difficultyRating: 2,
                    tags: ["Dinner"]
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
