//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by David Pittman on 1/5/25.
//

import SwiftUI


@main
struct LandmarksApp: App {
    @State private var modelData = ModelData()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
