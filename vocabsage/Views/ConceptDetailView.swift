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
    @State private var selectedTab = 0
    @State private var showAddNote = false
    
    init(concept: Concept) {
        self.concept = concept
        _viewModel = StateObject(wrappedValue: ConceptDetailViewModel(concept: concept, viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var displayTitle: String {
        let title = concept.title ?? ""
        return title.hasPrefix("[Example] ") ? String(title.dropFirst(10)) : title
    }
    
    var isExample: Bool {
        (concept.title ?? "").hasPrefix("[Example]")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Above the fold: Title, Definition, Confidence
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        if isExample {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.red)
                        }
                        Text(displayTitle)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Text(concept.summary ?? "")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    // Confidence Selector
                    ConfidenceSelectorView(concept: concept)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Tabs
                VStack(alignment: .leading, spacing: 0) {
                    // Tab Picker
                    Picker("Tab", selection: $selectedTab) {
                        Text("Explain").tag(0)
                        Text("Use").tag(1)
                        Text("Pitfalls").tag(2)
                        Text("Test").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    // Tab Content
                    Group {
                        switch selectedTab {
                        case 0:
                            ExplainTabView(concept: concept, viewModel: viewModel)
                        case 1:
                            UseTabView(concept: concept)
                        case 2:
                            PitfallsTabView(concept: concept)
                        case 3:
                            TestTabView(concept: concept)
                        default:
                            ExplainTabView(concept: concept, viewModel: viewModel)
                        }
                    }
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
                    Button {
                        showAddNote = true
                    } label: {
                        Label("Add Note", systemImage: "note.text")
                    }
                    Button("Edit") {
                        viewModel.isEditing = true
                    }
                }
            }
        }
        .sheet(isPresented: $showAddNote) {
            AddNoteView(concept: concept)
        }
        .onAppear {
            viewModel.viewContext = viewContext
            viewModel.loadConcept(concept)
        }
    }
}

struct ConfidenceSelectorView: View {
    @ObservedObject var concept: Concept
    @Environment(\.managedObjectContext) private var viewContext
    
    var currentConfidence: Int16 {
        concept.confidence ?? 0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text("Confidence:")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
            
            ForEach(0..<3) { level in
                Button {
                    concept.confidence = Int16(level)
                    concept.lastReviewedAt = Date()
                    try? viewContext.save()
                } label: {
                    Text(emojiForLevel(level))
                        .font(.system(size: 32))
                        .opacity(level == currentConfidence ? 1.0 : 0.4)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func emojiForLevel(_ level: Int) -> String {
        switch level {
        case 0: return "😕"
        case 1: return "🙂"
        case 2: return "😄"
        default: return "😕"
        }
    }
}

struct ExplainTabView: View {
    let concept: Concept
    @ObservedObject var viewModel: ConceptDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Plain definition
            if let mentalModel = concept.mentalModel, !mentalModel.isEmpty {
                ConceptSectionView(
                    title: "Definition",
                    content: .constant(mentalModel),
                    isEditing: false,
                    placeholder: ""
                )
            }
            
            // Analogy
            if let whyItExists = concept.whyItExists, !whyItExists.isEmpty {
                ConceptSectionView(
                    title: "Analogy",
                    content: .constant(whyItExists),
                    isEditing: false,
                    placeholder: ""
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct UseTabView: View {
    let concept: Concept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Real systems
            if let tradeoffs = concept.tradeoffs, !tradeoffs.isEmpty {
                ConceptSectionView(
                    title: "When to Use / When Not to",
                    content: .constant(tradeoffs),
                    isEditing: false,
                    placeholder: ""
                )
            }
            
            // User notes
            if let userNotes = concept.userNotes, !userNotes.isEmpty {
                ConceptSectionView(
                    title: "My Notes",
                    content: .constant(userNotes),
                    isEditing: false,
                    placeholder: ""
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct PitfallsTabView: View {
    let concept: Concept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let gotchas = concept.gotchas, !gotchas.isEmpty {
                ConceptSectionView(
                    title: "Common Misunderstandings",
                    content: .constant(gotchas),
                    isEditing: false,
                    placeholder: ""
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct TestTabView: View {
    let concept: Concept
    @State private var showAnswer = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Quick Test")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What is \(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "this concept")?")
                    .font(.system(size: 18, weight: .semibold))
                
                if showAnswer {
                    Text(concept.summary ?? "")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                } else {
                    Button("Show Answer") {
                        withAnimation {
                            showAnswer = true
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.top, 8)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
        }
    }
}

struct AddNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var concept: Concept
    @State private var noteText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 200)
                } header: {
                    Text("Add Your Note")
                } footer: {
                    Text("Add your own examples, mental models, or insights about this concept.")
                }
            }
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        concept.userNotes = noteText
                        try? viewContext.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                noteText = concept.userNotes ?? ""
            }
        }
    }
}

struct ConceptSectionView: View {
    let title: String
    @Binding var content: String
    let isEditing: Bool
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            
            if content.isEmpty && !isEditing {
                Text(placeholder)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.7))
                    .italic()
            } else {
                Text(content)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
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
