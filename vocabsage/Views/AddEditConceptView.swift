//
//  AddEditConceptView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct AddEditConceptView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let concept: Concept?
    @StateObject private var viewModel: AddEditConceptViewModel
    
    init(concept: Concept? = nil) {
        self.concept = concept
        _viewModel = StateObject(wrappedValue: AddEditConceptViewModel(
            concept: concept,
            viewContext: PersistenceController.shared.container.viewContext
        ))
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $viewModel.title)
                    .font(.system(size: 17, weight: .semibold))
                
                TextField("Summary", text: $viewModel.summary, axis: .vertical)
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(2...4)
            } header: {
                Text("Basic Information")
                    .font(.system(size: 13, weight: .medium))
            }
            
            Section {
                TextEditor(text: $viewModel.mentalModel)
                    .font(.system(size: 16, weight: .regular))
                    .frame(minHeight: 120)
                    .overlay(
                        Group {
                            if viewModel.mentalModel.isEmpty {
                                Text("How you think about this concept...")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.7))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )
            } header: {
                Text("Mental Model")
                    .font(.system(size: 13, weight: .medium))
            }
            
            Section {
                TextEditor(text: $viewModel.whyItExists)
                    .font(.system(size: 16, weight: .regular))
                    .frame(minHeight: 120)
                    .overlay(
                        Group {
                            if viewModel.whyItExists.isEmpty {
                                Text("The problem this solves...")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.7))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )
            } header: {
                Text("Why It Exists")
                    .font(.system(size: 13, weight: .medium))
            }
            
            Section {
                TextEditor(text: $viewModel.tradeoffs)
                    .font(.system(size: 16, weight: .regular))
                    .frame(minHeight: 120)
                    .overlay(
                        Group {
                            if viewModel.tradeoffs.isEmpty {
                                Text("Pros and cons...")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.7))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )
            } header: {
                Text("Trade-offs")
                    .font(.system(size: 13, weight: .medium))
            }
            
            Section {
                TextEditor(text: $viewModel.gotchas)
                    .font(.system(size: 16, weight: .regular))
                    .frame(minHeight: 120)
                    .overlay(
                        Group {
                            if viewModel.gotchas.isEmpty {
                                Text("Common pitfalls and things to watch out for...")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.7))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )
            } header: {
                Text("Gotchas")
                    .font(.system(size: 13, weight: .medium))
            }
        }
        .navigationTitle(viewModel.isEditing ? "Edit Concept" : "New Concept")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if viewModel.save() {
                        dismiss()
                    }
                }
                .fontWeight(.semibold)
                .disabled(viewModel.title.isEmpty || viewModel.summary.isEmpty)
            }
        }
        .onAppear {
            viewModel.viewContext = viewContext
        }
    }
}

#Preview {
    NavigationView {
        AddEditConceptView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

