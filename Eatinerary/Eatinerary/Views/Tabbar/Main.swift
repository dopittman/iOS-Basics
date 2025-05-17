//
//  SwiftUIView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Image(systemName: "fork.knife.circle")
                    Text("Recipes")
                }

            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Meal Plan")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Shopping List")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Browser")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Ask AI (Beta)")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Misc1")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Misc2")
                }
        }
        .onAppear{
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(.black) // Set the accent color for the selected tab
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
        MainView()
    }
}
