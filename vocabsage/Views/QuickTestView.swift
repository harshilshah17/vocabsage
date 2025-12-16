//
//  QuickTestView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct QuickTestView: View {
    @Environment(\.dismiss) private var dismiss
    let concept: Concept
    @State private var showAnswer = false
    @State private var userAnswer = ""
    
    var displayTitle: String {
        let title = concept.title ?? ""
        return title.hasPrefix("[Example] ") ? String(title.dropFirst(10)) : title
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Question
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Test")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("What is \(displayTitle)?")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Try to explain this concept in your own words.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                
                // Answer input (optional)
                if !showAnswer {
                    TextEditor(text: $userAnswer)
                        .font(.system(size: 16, weight: .regular))
                        .frame(minHeight: 150)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                        .overlay(
                            Group {
                                if userAnswer.isEmpty {
                                    Text("Write your answer here...")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.7))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                
                // Show answer button or answer display
                if !showAnswer {
                    Button {
                        withAnimation {
                            showAnswer = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("Show Answer")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue)
                        )
                    }
                } else {
                    // Answer display
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Answer")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text(concept.summary ?? "")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    )
                    
                    // Additional details if available
                    if let mentalModel = concept.mentalModel, !mentalModel.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mental Model")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text(mentalModel)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Test")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    dismiss()
                }
            }
            if showAnswer {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: ConceptDetailView(concept: concept)) {
                        Text("Learn More")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let concept = Concept(context: context)
    concept.id = UUID()
    concept.title = "Example Concept"
    concept.summary = "This is an example concept for preview"
    concept.createdAt = Date()
    
    return NavigationView {
        QuickTestView(concept: concept)
    }
    .environment(\.managedObjectContext, context)
}

