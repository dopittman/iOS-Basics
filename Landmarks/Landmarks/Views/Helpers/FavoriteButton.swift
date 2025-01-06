//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by David Pittman on 1/5/25.
//

import SwiftUI


struct FavoriteButton: View {
    @Binding var isSet: Bool


    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .yellow : .gray)
        }
    }
}


#Preview {
    Group {
        FavoriteButton(isSet: .constant(true))
        FavoriteButton(isSet: .constant(false))
    }
}
