//
//  SetDifficultyRating.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

struct SetDifficultyRating: View {
    @State private var rating = 0
    var body: some View {
        stars
            .overlay{
            GeometryReader { proxy in
                Rectangle()
                    .foregroundStyle(Color.accentColor)
                    .frame(width: CGFloat(rating) / 5 * proxy.size.width)
                    .frame(maxWidth: .infinity, alignment: .leading) // <-- Here
                    .animation(.bouncy, value: rating)
                    .allowsHitTesting(false)
                    .mask(stars)
            }
        }
    }
    
    private var stars: some View {
        HStack {
            ForEach(1...5, id:\.self) { i in
                Image(systemName: "circle.fill")
                    .foregroundStyle(.gray)
                    .font(.largeTitle)
                    .onTapGesture {
                        rating = i
                    }
            }
        }
    }
}

struct SetDifficultyRating_Previews: PreviewProvider {
    static var previews: some View {
        SetDifficultyRating()
    }
}
