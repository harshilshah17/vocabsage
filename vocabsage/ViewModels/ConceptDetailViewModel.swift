//
//  ConceptDetailViewModel.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class ConceptDetailViewModel: ObservableObject {
    @Published var isEditing: Bool = false
    @Published var title: String = ""
    @Published var summary: String = ""
    @Published var mentalModel: String = ""
    @Published var whyItExists: String = ""
    @Published var tradeoffs: String = ""
    @Published var gotchas: String = ""
    
    private var concept: Concept?
    var viewContext: NSManagedObjectContext
    
    init(concept: Concept?, viewContext: NSManagedObjectContext) {
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
    
    func saveChanges() {
        guard let concept = concept else { return }
        
        concept.title = title
        concept.summary = summary
        concept.mentalModel = mentalModel.isEmpty ? nil : mentalModel
        concept.whyItExists = whyItExists.isEmpty ? nil : whyItExists
        concept.tradeoffs = tradeoffs.isEmpty ? nil : tradeoffs
        concept.gotchas = gotchas.isEmpty ? nil : gotchas
        concept.lastReviewedAt = Date()
        
        do {
            try viewContext.save()
            isEditing = false
        } catch {
            print("Error saving concept: \(error)")
        }
    }
    
    func cancelEditing() {
        if let concept = concept {
            loadConcept(concept)
        }
        isEditing = false
    }
    
    func markAsReviewed() {
        guard let concept = concept else { return }
        concept.lastReviewedAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Error marking as reviewed: \(error)")
        }
    }
}

