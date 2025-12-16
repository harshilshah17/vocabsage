//
//  YouView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct YouView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Concept.createdAt, ascending: false)],
        animation: .default)
    private var concepts: FetchedResults<Concept>
    
    @State private var showSettings = false
    
    var masteredCount: Int {
        concepts.filter { ($0.confidence ?? 0) >= 2 }.count
    }
    
    var totalConcepts: Int {
        concepts.count
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats
                    StatsSection(masteredCount: masteredCount, totalConcepts: totalConcepts)
                    
                    // My Notes
                    MyNotesSection(concepts: Array(concepts))
                    
                    // Settings
                    SettingsSection(showSettings: $showSettings)
                }
                .padding()
            }
            .navigationTitle("You")
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct StatsSection: View {
    let masteredCount: Int
    let totalConcepts: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stats")
                .font(.system(size: 20, weight: .bold))
            
            HStack(spacing: 16) {
                StatCardView(
                    title: "Mastered",
                    value: "\(masteredCount)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatCardView(
                    title: "Total",
                    value: "\(totalConcepts)",
                    icon: "book.fill",
                    color: .blue
                )
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
            
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
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

struct MyNotesSection: View {
    let concepts: [Concept]
    
    var conceptsWithNotes: [Concept] {
        concepts.filter { concept in
            if let notes = concept.userNotes {
                return !notes.isEmpty
            }
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Notes")
                .font(.system(size: 20, weight: .bold))
            
            if conceptsWithNotes.isEmpty {
                Text("No notes yet. Add notes to concepts to see them here.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
            } else {
                ForEach(conceptsWithNotes.prefix(5)) { concept in
                    NavigationLink(destination: ConceptDetailView(concept: concept)) {
                        NoteCardView(concept: concept)
                    }
                }
            }
        }
    }
}

struct NoteCardView: View {
    let concept: Concept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(concept.title?.replacingOccurrences(of: "[Example] ", with: "") ?? "")
                .font(.system(size: 16, weight: .semibold))
            
            Text(concept.userNotes ?? "")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.thinMaterial)
        )
    }
}

struct SettingsSection: View {
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.system(size: 20, weight: .bold))
            
            Button {
                showSettings = true
            } label: {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18))
                    Text("App Settings")
                        .font(.system(size: 16, weight: .regular))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.thinMaterial)
                )
            }
        }
    }
}

#Preview {
    YouView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

