//
//  LearnView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct LearnView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concept.nextReviewDate, ascending: true)],
        animation: .default)
    private var concepts: FetchedResults<Concept>
    
    @State private var selectedMode = 0
    @State private var currentConceptIndex = 0
    @State private var showResult = false
    
    var modes = ["Review", "Flashcards", "Scenarios"]
    
    var reviewConcepts: [Concept] {
        Array(concepts.filter { concept in
            concept.nextReviewDate == nil || concept.nextReviewDate! <= Date()
        })
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Mode selector
                Picker("Mode", selection: $selectedMode) {
                    ForEach(0..<modes.count, id: \.self) { index in
                        Text(modes[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content based on mode
                if reviewConcepts.isEmpty {
                    emptyStateView
                } else {
                    switch selectedMode {
                    case 0:
                        ReviewModeView(concepts: reviewConcepts)
                    case 1:
                        FlashcardModeView(concepts: reviewConcepts)
                    case 2:
                        ScenarioModeView(concepts: reviewConcepts)
                    default:
                        ReviewModeView(concepts: reviewConcepts)
                    }
                }
            }
            .navigationTitle("Learn")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundColor(.green)
            
            Text("All caught up!")
                .font(.system(size: 22, weight: .semibold))
            
            Text("No concepts need review right now")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ReviewModeView: View {
    let concepts: [Concept]
    @State private var currentIndex = 0
    @State private var showAnswer = false
    
    var currentConcept: Concept? {
        guard currentIndex < concepts.count else { return nil }
        return concepts[currentIndex]
    }
    
    var body: some View {
        if let concept = currentConcept {
            ScrollView {
                VStack(spacing: 24) {
                    // Concept card
                    VStack(alignment: .leading, spacing: 16) {
                        Text(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "")
                            .font(.system(size: 28, weight: .bold))
                        
                        if showAnswer {
                            Text(concept.summary ?? "")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.secondary)
                        } else {
                            Text("Tap to reveal definition")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.secondary.opacity(0.6))
                                .italic()
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    )
                    .onTapGesture {
                        withAnimation {
                            showAnswer.toggle()
                        }
                    }
                    
                    if showAnswer {
                        // Confidence buttons
                        HStack(spacing: 12) {
                            ConfidenceButton(emoji: "😕", label: "Unsure", confidence: 0) {
                                markConfidence(0)
                            }
                            ConfidenceButton(emoji: "🙂", label: "Getting it", confidence: 1) {
                                markConfidence(1)
                            }
                            ConfidenceButton(emoji: "😄", label: "Know it", confidence: 2) {
                                markConfidence(2)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func markConfidence(_ level: Int16) {
        guard let concept = currentConcept else { return }
        concept.confidence = level
        concept.reviewCount = (concept.reviewCount ?? 0) + 1
        concept.lastReviewedAt = Date()
        
        // Calculate next review date (spaced repetition)
        let daysUntilNextReview = calculateNextReview(confidence: level, reviewCount: Int(concept.reviewCount ?? 0))
        concept.nextReviewDate = Calendar.current.date(byAdding: .day, value: daysUntilNextReview, to: Date())
        
        // Move to next concept
        if currentIndex < concepts.count - 1 {
            currentIndex += 1
            showAnswer = false
        }
    }
    
    private func calculateNextReview(confidence: Int16, reviewCount: Int) -> Int {
        switch confidence {
        case 0: return 1 // Review tomorrow
        case 1: return min(3 + reviewCount, 7) // 3-7 days
        case 2: return min(7 + reviewCount * 2, 30) // 7-30 days
        default: return 1
        }
    }
}

struct ConfidenceButton: View {
    let emoji: String
    let label: String
    let confidence: Int16
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 32))
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.thinMaterial)
            )
        }
    }
}

struct FlashcardModeView: View {
    let concepts: [Concept]
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
    var body: some View {
        // Similar to ReviewMode but with swipe gestures
        ReviewModeView(concepts: concepts)
    }
}

struct ScenarioModeView: View {
    let concepts: [Concept]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if currentIndex < concepts.count {
                    let concept = concepts[currentIndex]
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Scenario")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("Where would you use \(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "this")?")
                            .font(.system(size: 22, weight: .bold))
                        
                        Text("Think of a real-world situation or system where this concept applies.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    )
                    
                    Button("Next Scenario") {
                        if currentIndex < concepts.count - 1 {
                            currentIndex += 1
                        }
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
            }
            .padding()
        }
    }
}

#Preview {
    LearnView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

