//
//  StepsListView.swift
//  Eatinerary
//
//  Created by David Pittman on 1/18/25.
//

import SwiftUI


struct StepsListView: View {
    let steps: [Step]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(steps) { step in
                // Container for full width
                HStack {
                    // Content container
                    HStack(alignment: .top, spacing: 12) {
                        // Circled number
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 28, height: 28)
                            
                            Text("\(step.number)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        
                        // Step instruction
                        Text(step.instruction)
                            .font(.body)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.componentAuto))
                )
            }
        }
    }
}

// Preview provider
struct StepsListView_Previews: PreviewProvider {
    static var previews: some View {
        StepsListView(steps: Step.sampleSteps)
            .preferredColorScheme(.light)
        
        StepsListView(steps: Step.sampleSteps)
            .preferredColorScheme(.dark)
    }
}
