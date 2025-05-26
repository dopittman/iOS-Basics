import Foundation

struct Tag: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
}

// Extension for sample data
extension Tag {
    static var sampleTags: [Tag] = [
        Tag(name: "Easy"),
        Tag(name: "Vegan"),
        Tag(name: "Vegetarian"),
        Tag(name: "Quick"),
        Tag(name: "Special"),
        Tag(name: "Healthy"),
        Tag(name: "Gluten-Free"),
        Tag(name: "Dairy-Free"),
        Tag(name: "Breakfast"),
        Tag(name: "Lunch"),
        Tag(name: "Dinner"),
        Tag(name: "Dessert"),
        Tag(name: "Italian"),
        Tag(name: "Mexican"),
        Tag(name: "Asian"),
        Tag(name: "Mediterranean")
    ]
} 