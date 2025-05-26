import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var selectedTag: Tag?
    let allTags: [Tag]
    let onTagSelected: (Tag) -> Void
    
    var filteredTags: [Tag] {
        if searchText.isEmpty {
            return []
        }
        return allTags.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search recipes...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        selectedTag = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Tag Suggestions
            if !filteredTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filteredTags) { tag in
                            TagChip(tag: tag, isSelected: selectedTag?.id == tag.id) {
                                selectedTag = tag
                                onTagSelected(tag)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))
            }
        }
    }
}

struct TagChip: View {
    let tag: Tag
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(tag.name)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

#Preview {
    SearchBarView(
        searchText: .constant(""),
        selectedTag: .constant(nil),
        allTags: Tag.sampleTags,
        onTagSelected: { _ in }
    )
} 