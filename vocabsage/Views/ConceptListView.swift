//
//  ConceptListView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct ConceptListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concept.createdAt, ascending: false)],
        animation: .default)
    private var concepts: FetchedResults<Concept>
    
    @StateObject private var viewModel = ConceptListViewModel()
    @State private var showingAddConcept = false
    @State private var showAskTheSage = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                let filteredConcepts = viewModel.filteredConcepts(concepts)
                
                if filteredConcepts.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredConcepts) { concept in
                            NavigationLink(destination: ConceptDetailView(concept: concept)) {
                                ConceptRowView(concept: concept)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteConcepts)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("VocabSage")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showAskTheSage = true }) {
                        Label("Ask the Sage", systemImage: "sparkles")
                    }
                }
                #endif
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddConcept = true }) {
                        Label("Add Concept", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddConcept) {
                NavigationView {
                    AddEditConceptView()
                }
            }
            #if os(iOS)
            .sheet(isPresented: $showAskTheSage) {
                NavigationView {
                    AskTheSageView()
                        .navigationTitle("Ask the Sage")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    showAskTheSage = false
                                }
                            }
                        }
                }
            }
            #endif
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 56, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Concepts Yet")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Tap the + button to add your first concept")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private func deleteConcepts(offsets: IndexSet) {
        let filteredConcepts = viewModel.filteredConcepts(concepts)
        withAnimation {
            offsets.map { filteredConcepts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting concept: \(error)")
            }
        }
    }
}

struct ConceptRowView: View {
    let concept: Concept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(concept.title ?? "")
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(.primary)
            
            Text(concept.summary ?? "")
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField("Search for a word", text: $text)
                .font(.system(size: 16, weight: .regular))
                .textFieldStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    ConceptListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

