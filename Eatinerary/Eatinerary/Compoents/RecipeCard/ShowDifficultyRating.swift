//
//  DifficultyRating.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

struct ShowDifficultyRating: View {
    @Binding var rating: Int

    init(rating: Binding<Int>) {
        self._rating = rating
    }

    var body: some View {
        HStack(spacing: 4) { // Adjust spacing as needed
            ForEach(1...rating, id: \.self) { index in
                Image(systemName: "circle.fill")
                    .foregroundStyle(color(for: index))
            }
        }
    }
    
    private func color(for index: Int) -> Color {
        let startColor = Color(hue: 0.402, saturation: 0.327, brightness: 0.853)
        let endColor = Color(hue: 0.045, saturation: 0.763, brightness: 0.935)
        let fraction = Double(index - 1) / 4.0 // Scale index to range [0, 1]
        return Color.blend(from: startColor, to: endColor, fraction: fraction)
    }
    
    
}
