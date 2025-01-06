//
//  CircleImage.swift
//  Eatinerary
//
//  Created by David Pittman on 1/5/25.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay(Circle().stroke(.white, lineWidth: 4))
            .shadow(radius: 7)
        
    }
}

#Preview {
    CircleImage()
}
