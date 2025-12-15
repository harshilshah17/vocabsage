//
//  ConceptListViewModel.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class ConceptListViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    func filteredConcepts(_ concepts: FetchedResults<Concept>) -> [Concept] {
        if searchText.isEmpty {
            return Array(concepts)
        }
        
        return concepts.filter { concept in
            (concept.title ?? "").localizedCaseInsensitiveContains(searchText) ||
            (concept.summary ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }
}

