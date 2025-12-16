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
    @State private var showSettings = false
    @State private var showDeleteAlert = false
    @State private var conceptsToDelete: IndexSet?
    @AppStorage("confirmBeforeDelete") private var confirmBeforeDelete = true
    
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
                    Button(action: { showSettings = true }) {
                        Label("Settings", systemImage: "gearshape")
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
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            #endif
            .alert("Delete Concepts", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    conceptsToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let offsets = conceptsToDelete {
                        performDelete(offsets: offsets)
                    }
                    conceptsToDelete = nil
                }
            } message: {
                if let offsets = conceptsToDelete {
                    let count = offsets.count
                    Text("Are you sure you want to delete \(count) concept\(count == 1 ? "" : "s")?")
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 56, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
                .padding(24)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                )
            
            VStack(spacing: 8) {
                Text("No Concepts Yet")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Tap the + button to add your first concept")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private func deleteConcepts(offsets: IndexSet) {
        if confirmBeforeDelete {
            conceptsToDelete = offsets
            showDeleteAlert = true
        } else {
            performDelete(offsets: offsets)
        }
    }
    
    private func performDelete(offsets: IndexSet) {
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
    
    private var isExample: Bool {
        (concept.title ?? "").hasPrefix("[Example]")
    }
    
    private var displayTitle: String {
        if isExample {
            return String((concept.title ?? "").dropFirst(10)) // Remove "[Example] "
        }
        return concept.title ?? ""
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    if isExample {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.red)
                    }
                    Text(displayTitle)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                }
                
                Text(concept.summary ?? "")
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
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
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        )
    }
}

#Preview {
    ConceptListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

