//
//  ConceptDetailView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct ConceptDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let concept: Concept
    @StateObject private var viewModel: ConceptDetailViewModel
    
    init(concept: Concept) {
        self.concept = concept
        // Temporary initialization, will be updated in onAppear
        _viewModel = StateObject(wrappedValue: ConceptDetailViewModel(concept: concept, viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Title and Summary
                VStack(alignment: .leading, spacing: 14) {
                    if viewModel.isEditing {
                        TextField("Title", text: $viewModel.title)
                            .font(.system(size: 34, weight: .bold))
                            .textFieldStyle(.plain)
                        
                        TextField("Summary", text: $viewModel.summary, axis: .vertical)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.secondary)
                            .textFieldStyle(.plain)
                            .lineLimit(2...4)
                    } else {
                        Text(concept.title ?? "")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(concept.summary ?? "")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Mental Model Section
                ConceptSectionView(
                    title: "Mental Model",
                    content: viewModel.isEditing ? $viewModel.mentalModel : .constant(concept.mentalModel ?? ""),
                    isEditing: viewModel.isEditing,
                    placeholder: "How you think about this concept..."
                )
                
                // Why It Exists Section
                ConceptSectionView(
                    title: "Why It Exists",
                    content: viewModel.isEditing ? $viewModel.whyItExists : .constant(concept.whyItExists ?? ""),
                    isEditing: viewModel.isEditing,
                    placeholder: "The problem this solves..."
                )
                
                // Trade-offs Section
                ConceptSectionView(
                    title: "Trade-offs",
                    content: viewModel.isEditing ? $viewModel.tradeoffs : .constant(concept.tradeoffs ?? ""),
                    isEditing: viewModel.isEditing,
                    placeholder: "Pros and cons..."
                )
                
                // Gotchas Section
                ConceptSectionView(
                    title: "Gotchas",
                    content: viewModel.isEditing ? $viewModel.gotchas : .constant(concept.gotchas ?? ""),
                    isEditing: viewModel.isEditing,
                    placeholder: "Common pitfalls and things to watch out for..."
                )
                
                // Metadata
                if !viewModel.isEditing {
                    VStack(alignment: .leading, spacing: 10) {
                        if let createdAt = concept.createdAt {
                            Label("Created \(createdAt, style: .date)", systemImage: "calendar")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                        if let lastReviewed = concept.lastReviewedAt {
                            Label("Last reviewed \(lastReviewed, style: .date)", systemImage: "clock")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if viewModel.isEditing {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                    }
                    Button("Save") {
                        viewModel.saveChanges()
                    }
                    .fontWeight(.semibold)
                } else {
                    Button("Edit") {
                        viewModel.isEditing = true
                    }
                    Button {
                        viewModel.markAsReviewed()
                    } label: {
                        Label("Mark Reviewed", systemImage: "checkmark.circle")
                    }
                }
            }
        }
        .onAppear {
            viewModel.viewContext = viewContext
            viewModel.loadConcept(concept)
        }
    }
}

struct ConceptSectionView: View {
    let title: String
    @Binding var content: String
    let isEditing: Bool
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            if isEditing {
                TextEditor(text: $content)
                    .font(.system(size: 17, weight: .regular))
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal, 20)
            } else {
                if content.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .italic()
                        .padding(.horizontal, 20)
                } else {
                    Text(content)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(6)
                        .padding(.horizontal, 20)
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
        ConceptDetailView(concept: concept)
    }
    .environment(\.managedObjectContext, context)
}

