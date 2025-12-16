//
//  HomeView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concept.createdAt, ascending: false)],
        animation: .default)
    private var concepts: FetchedResults<Concept>
    
    private let viewModel = HomeViewModel()
    @State private var showSearch = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Today's Card
                    if let todaysCard = viewModel.todaysCard(concepts: Array(concepts)) {
                        TodaysCardView(concept: todaysCard)
                    }
                    
                    // Continue Learning
                    if !viewModel.continueLearningConcepts(concepts: Array(concepts)).isEmpty {
                        ContinueLearningSection(concepts: viewModel.continueLearningConcepts(concepts: Array(concepts)))
                    }
                }
                .padding()
            }
            .navigationTitle("VocabSage")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSearch = true
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $showSearch) {
                SearchView()
            }
        }
    }
}

struct TodaysCardView: View {
    let concept: Concept
    @State private var showDetail = false
    @State private var showTest = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Card")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(concept.summary ?? "")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button {
                    showTest = true
                } label: {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                        Text("Test Me")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue)
                    )
                }
                
                Button {
                    showDetail = true
                } label: {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("Explain It")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.1))
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
        )
        .sheet(isPresented: $showDetail) {
            NavigationView {
                ConceptDetailView(concept: concept)
            }
        }
        .sheet(isPresented: $showTest) {
            NavigationView {
                QuickTestView(concept: concept)
            }
        }
    }
}

struct ContinueLearningSection: View {
    let concepts: [Concept]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Continue Learning")
                .font(.system(size: 20, weight: .bold))
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(concepts.prefix(5)) { concept in
                        NavigationLink(destination: ConceptDetailView(concept: concept)) {
                            ConceptCardView(concept: concept)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct ConceptCardView: View {
    let concept: Concept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(concept.summary ?? "")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(width: 160, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concept.createdAt, ascending: false)],
        animation: .default)
    private var concepts: FetchedResults<Concept>
    
    @State private var searchText = ""
    
    var filteredConcepts: [Concept] {
        if searchText.isEmpty {
            return Array(concepts)
        }
        return concepts.filter { concept in
            (concept.title ?? "").localizedCaseInsensitiveContains(searchText) ||
            (concept.summary ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredConcepts) { concept in
                    NavigationLink(destination: ConceptDetailView(concept: concept)) {
                        ConceptRowView(concept: concept)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a word")
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

class HomeViewModel {
    func todaysCard(concepts: [Concept]) -> Concept? {
        // Return a random concept or one that needs review
        let needsReview = concepts.filter { concept in
            concept.nextReviewDate == nil || concept.nextReviewDate! <= Date()
        }
        return needsReview.randomElement() ?? concepts.randomElement()
    }
    
    func continueLearningConcepts(concepts: [Concept]) -> [Concept] {
        // Return recently viewed or weak concepts
        concepts
            .sorted { ($0.lastReviewedAt ?? Date.distantPast) > ($1.lastReviewedAt ?? Date.distantPast) }
            .prefix(5)
            .map { $0 }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

