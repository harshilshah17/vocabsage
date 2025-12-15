//
//  AddEditConceptViewModel.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class AddEditConceptViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var summary: String = ""
    @Published var mentalModel: String = ""
    @Published var whyItExists: String = ""
    @Published var tradeoffs: String = ""
    @Published var gotchas: String = ""
    
    private var concept: Concept?
    var viewContext: NSManagedObjectContext
    
    init(concept: Concept? = nil, viewContext: NSManagedObjectContext) {
        self.concept = concept
        self.viewContext = viewContext
        
        if let concept = concept {
            loadConcept(concept)
        }
    }
    
    func loadConcept(_ concept: Concept) {
        self.concept = concept
        self.title = concept.title ?? ""
        self.summary = concept.summary ?? ""
        self.mentalModel = concept.mentalModel ?? ""
        self.whyItExists = concept.whyItExists ?? ""
        self.tradeoffs = concept.tradeoffs ?? ""
        self.gotchas = concept.gotchas ?? ""
    }
    
    func save() -> Bool {
        guard !title.isEmpty, !summary.isEmpty else {
            return false
        }
        
        let conceptToSave: Concept
        if let existingConcept = concept {
            conceptToSave = existingConcept
        } else {
            conceptToSave = Concept(context: viewContext)
            conceptToSave.id = UUID()
            conceptToSave.createdAt = Date()
        }
        
        conceptToSave.title = title
        conceptToSave.summary = summary
        conceptToSave.mentalModel = mentalModel.isEmpty ? nil : mentalModel
        conceptToSave.whyItExists = whyItExists.isEmpty ? nil : whyItExists
        conceptToSave.tradeoffs = tradeoffs.isEmpty ? nil : tradeoffs
        conceptToSave.gotchas = gotchas.isEmpty ? nil : gotchas
        conceptToSave.lastReviewedAt = Date()
        
        do {
            try viewContext.save()
            return true
        } catch {
            print("Error saving concept: \(error)")
            return false
        }
    }
    
    var isEditing: Bool {
        concept != nil
    }
}

