import SwiftUI
import PhotosUI

class IngredientState: ObservableObject {
    @Published var item: String
    @Published var quantity: Double
    @Published var unit: String
    
    init(item: String = "", quantity: Double = 0, unit: String = "") {
        self.item = item
        self.quantity = quantity
        self.unit = unit
    }
    
    func toIngredient() -> Recipe.Ingredient {
        Recipe.Ingredient(item: item, quantity: quantity, unit: unit)
    }
}

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var recipeData: RecipeData
    
    @State private var name = ""
    @State private var prepTime = ""
    @State private var cookTime = ""
    @State private var servings = ""
    @State private var notes = ""
    @State private var effortLevel = "Easy"
    @State private var selectedTags: Set<Tag> = []
    @State private var ingredientStates: [IngredientState] = []
    @State private var steps: [String] = [""]
    @State private var selectedImage: PhotosPickerItem?
    @State private var recipeImage: Image?
    @State private var showingImagePicker = false
    
    let effortLevels = ["Easy", "Medium", "Hard"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // Image Section
                    ZStack(alignment: .topLeading) {
                        if let recipeImage = recipeImage {
                            recipeImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.horizontal, 8.0)
                                .frame(height: 150)
                                .clipped()
                        } else {
                            PhotosPicker(selection: $selectedImage, matching: .images) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            .padding(12)
                        }                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Basic Info Section
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Recipe Name", text: $name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack(spacing: 8) {
                            TextField("Prep Time", text: $prepTime)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Cook Time", text: $cookTime)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack(spacing: 8) {
                            TextField("Servings", text: $servings)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Picker("Effort Level", selection: $effortLevel) {
                                ForEach(effortLevels, id: \.self) { level in
                                    Text(level).tag(level)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Tags Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tags")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(recipeData.tags) { tag in
                                    TagChip(
                                        tag: tag,
                                        isSelected: selectedTags.contains(tag)
                                    ) {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Ingredients Section
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Ingredients")
                                .font(.headline)
                        }
                        
                        ForEach(ingredientStates.indices, id: \.self) { index in
                            HStack(spacing: 8) {
                                TextField("Item", text: $ingredientStates[index].item)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("Qty", value: $ingredientStates[index].quantity, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 50)
                                
                                TextField("Unit", text: $ingredientStates[index].unit)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 50)
                                
                                Button(action: { removeIngredient(at: index) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        HStack(){
                            Spacer()
                            Button(action: addIngredient) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        .padding(.top, 4.0)
                    }
                    .padding(.horizontal)
                    
                    // Steps Section
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Steps")
                                .font(.headline)
                        }
                        
                        ForEach(steps.indices, id: \.self) { index in
                            HStack(spacing: 8) {
                                Text("\(index + 1).")
                                    .foregroundColor(.gray)
                                    .frame(width: 25, alignment: .leading)
                                TextField("Step description", text: $steps[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                if steps.count > 1 {
                                    Button(action: { removeStep(at: index) }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        HStack(){
                            Spacer()
                            Button(action: addStep) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        .padding(.top, 4.0)
                    }
                    .padding(.horizontal)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notes")
                            .font(.headline)
                        TextEditor(text: $notes)
                            .frame(height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2))
                            )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onChange(of: selectedImage) { _ in
                Task {
                    if let data = try? await selectedImage?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        recipeImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
    
    private func addIngredient() {
        ingredientStates.append(IngredientState())
    }
    
    private func removeIngredient(at index: Int) {
        ingredientStates.remove(at: index)
    }
    
    private func addStep() {
        steps.append("")
    }
    
    private func removeStep(at index: Int) {
        steps.remove(at: index)
    }
    
    private func saveRecipe() {
        let ingredients = ingredientStates.map { $0.toIngredient() }
        
        // Filter out empty steps
        let recipeSteps = steps.filter { !$0.isEmpty }
        
        let newRecipe = Recipe(
            name: name,
            prepTime: prepTime,
            cookTime: cookTime,
            ingredients: ingredients,
            steps: recipeSteps,
            servings: servings,
            notes: notes,
            nutrition: ["Calories: 0", "Protein: 0g", "Carbs: 0g", "Fat: 0g"], // Default nutrition values
            tags: Array(selectedTags.map { $0.name }),
            effortLevel: effortLevel,
            image: nil,
            isFavorite: false
        )
        
        // Convert SwiftUI Image to UIImage if available
        var uiImage: UIImage?
        if let recipeImage = recipeImage {
            let renderer = ImageRenderer(content: recipeImage)
            uiImage = renderer.uiImage
        }
        
        recipeData.addRecipe(newRecipe, image: uiImage)
        dismiss()
    }
}

#Preview {
    AddRecipeView(recipeData: RecipeData())
} 
