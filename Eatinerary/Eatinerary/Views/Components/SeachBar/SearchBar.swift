//
//  SearchBar.swift
//  Eatinerary
//
//  Created by David Pittman on 1/12/25.
//

import SwiftUI

struct SearchBar: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink {
                        Text(name)
                    } label: {
                        Text(name)
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

#Preview {
    SearchBar()
}
