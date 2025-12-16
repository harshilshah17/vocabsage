//
//  ExploreView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concept.title, ascending: true)],
        animation: .default)
    private var concepts: FetchedResults<Concept>
    
    @State private var showCompare = false
    
    let collections = [
        Collection(name: "System Design Core", icon: "cpu", concepts: []),
        Collection(name: "Distributed Systems", icon: "network", concepts: []),
        Collection(name: "Databases", icon: "externaldrive", concepts: []),
        Collection(name: "Infrastructure", icon: "server.rack", concepts: []),
        Collection(name: "Messaging", icon: "message", concepts: [])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Collections
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Collections")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal, 4)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(collections) { collection in
                                NavigationLink(destination: CollectionDetailView(collection: collection, concepts: Array(concepts))) {
                                    CollectionCardView(collection: collection)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // Compare
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Compare")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal, 4)
                        
                        Button {
                            showCompare = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.left.arrow.right")
                                    .font(.system(size: 20))
                                Text("Compare Concepts")
                                    .font(.system(size: 16, weight: .semibold))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .foregroundColor(.primary)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.thinMaterial)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .padding()
            }
            .navigationTitle("Explore")
            .sheet(isPresented: $showCompare) {
                CompareView(concepts: Array(concepts))
            }
        }
    }
}

struct Collection: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var concepts: [Concept]
}

struct CollectionCardView: View {
    let collection: Collection
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: collection.icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.blue)
            
            Text(collection.name)
                .font(.system(size: 15, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct CollectionDetailView: View {
    let collection: Collection
    let concepts: [Concept]
    
    var filteredConcepts: [Concept] {
        // Filter concepts by collection (for now, return all)
        concepts
    }
    
    var body: some View {
        List {
            ForEach(filteredConcepts) { concept in
                NavigationLink(destination: ConceptDetailView(concept: concept)) {
                    ConceptRowView(concept: concept)
                }
            }
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CompareView: View {
    let concepts: [Concept]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedConcept1: Concept?
    @State private var selectedConcept2: Concept?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let concept1 = selectedConcept1, let concept2 = selectedConcept2 {
                    // Side-by-side comparison
                    ScrollView {
                        HStack(alignment: .top, spacing: 16) {
                            CompareCardView(concept: concept1)
                            CompareCardView(concept: concept2)
                        }
                        .padding()
                    }
                } else {
                    // Selection view
                    VStack(spacing: 16) {
                        Text("Select two concepts to compare")
                            .font(.system(size: 18, weight: .semibold))
                        
                        List {
                            ForEach(concepts) { concept in
                                Button {
                                    if selectedConcept1 == nil {
                                        selectedConcept1 = concept
                                    } else if selectedConcept2 == nil {
                                        selectedConcept2 = concept
                                    }
                                } label: {
                                    HStack {
                                        Text(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "")
                                        Spacer()
                                        if selectedConcept1?.id == concept.id || selectedConcept2?.id == concept.id {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                if selectedConcept1 != nil && selectedConcept2 != nil {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Reset") {
                            selectedConcept1 = nil
                            selectedConcept2 = nil
                        }
                    }
                }
            }
        }
    }
}

struct CompareCardView: View {
    let concept: Concept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "")
                .font(.system(size: 20, weight: .bold))
            
            Text(concept.summary ?? "")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
            
            if let tradeoffs = concept.tradeoffs, !tradeoffs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Trade-offs")
                        .font(.system(size: 16, weight: .semibold))
                    Text(tradeoffs)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    ExploreView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

