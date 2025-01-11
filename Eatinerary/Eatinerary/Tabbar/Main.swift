//
//  SwiftUIView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var tabSelection: Int = 0

    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Image(systemName: "fork.knife.circle")
                    Text("Recipes")
                }
                .onAppear {
                    tabSelection = 0
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .onAppear{
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(.blue) // Set the accent color for the selected tab
    }
}

struct SearchView: View {
    var body: some View {
        VStack {
            Text("Search")
                .font(.largeTitle)
                .padding()
        }
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
