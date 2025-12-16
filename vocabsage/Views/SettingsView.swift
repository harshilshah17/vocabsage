//
//  SettingsView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("showSampleConcepts") private var showSampleConcepts = true
    @AppStorage("confirmBeforeDelete") private var confirmBeforeDelete = true
    @State private var showDeleteAllAlert = false
    @State private var showClearDataAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Show sample concepts", isOn: $showSampleConcepts)
                        .font(.system(size: 16, weight: .regular))
                } header: {
                    Text("Content")
                        .font(.system(size: 13, weight: .medium))
                } footer: {
                    Text("Sample concepts are marked as example content and can be removed.")
                        .font(.system(size: 13, weight: .regular))
                }
                
                Section {
                    Toggle("Confirm before delete", isOn: $confirmBeforeDelete)
                        .font(.system(size: 16, weight: .regular))
                } header: {
                    Text("Safety")
                        .font(.system(size: 13, weight: .medium))
                } footer: {
                    Text("Require confirmation before deleting concepts.")
                        .font(.system(size: 13, weight: .regular))
                }
                
                Section {
                    Button(role: .destructive) {
                        showClearDataAlert = true
                    } label: {
                        HStack {
                            Text("Clear All Data")
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                        }
                    }
                } header: {
                    Text("Data Management")
                        .font(.system(size: 13, weight: .medium))
                } footer: {
                    Text("Permanently delete all concepts. This action cannot be undone.")
                        .font(.system(size: 13, weight: .regular))
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy")
                            .font(.system(size: 16, weight: .semibold))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("No account required", systemImage: "person.crop.circle.badge.xmark")
                                .font(.system(size: 14, weight: .regular))
                            Label("No tracking", systemImage: "eye.slash")
                                .font(.system(size: 14, weight: .regular))
                            Label("No analytics", systemImage: "chart.bar.xaxis")
                                .font(.system(size: 14, weight: .regular))
                            Label("All data stored locally", systemImage: "lock.shield")
                                .font(.system(size: 14, weight: .regular))
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Privacy")
                    .font(.system(size: 13, weight: .medium))
                } footer: {
                    Text("VocabSage respects your privacy. All data is stored locally on your device and never shared.")
                        .font(.system(size: 13, weight: .regular))
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Clear All Data", isPresented: $showClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete All", role: .destructive) {
                    deleteAllConcepts()
                }
            } message: {
                Text("This will permanently delete all concepts. This action cannot be undone.")
            }
        }
    }
    
    private func deleteAllConcepts() {
        let fetchRequest: NSFetchRequest<Concept> = Concept.fetchRequest()
        
        do {
            let allConcepts = try viewContext.fetch(fetchRequest)
            allConcepts.forEach { viewContext.delete($0) }
            try viewContext.save()
        } catch {
            print("Error deleting all concepts: \(error)")
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

