//
//  StepModel.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import Foundation

struct Step: Identifiable, Codable {
    let id: UUID
    let number: Int
    let instruction: String
    
    init(id: UUID = UUID(), number: Int, instruction: String) {
        self.id = id
        self.number = number
        self.instruction = instruction
    }
}

// Extension to help convert string array to Step array
extension Array where Element == String {
    func toSteps() -> [Step] {
        self.enumerated().map { (index, instruction) in
            Step(number: index + 1, instruction: instruction)
        }
    }
}

// Extension for Step to include sample data
extension Step {
    static var sampleSteps: [Step] = [
        "Cook the spaghetti according to package instructions.",
        "In a pan, cook pancetta until crispy.",
        "Whisk eggs and Parmesan together in a bowl.",
        "Combine spaghetti, pancetta, and egg mixture, stirring quickly to coat the pasta.",
        "Season with salt and pepper and serve."
    ].toSteps()
}
