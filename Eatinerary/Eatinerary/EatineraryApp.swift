//
//  EatineraryApp.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

@main
struct EatineraryApp: App {
    @StateObject private var recipeData = RecipeData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeData)
        }
    }
}
