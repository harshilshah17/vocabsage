//
//  ContentView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showAskTheSage = false
    
    var body: some View {
        #if os(macOS)
        HSplitView {
            ConceptListView()
                .frame(minWidth: 400)
            
            if showAskTheSage {
                AskTheSageView()
                    .frame(minWidth: 300, maxWidth: 400)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: { showAskTheSage.toggle() }) {
                    Label("Ask the Sage", systemImage: showAskTheSage ? "sparkles.fill" : "sparkles")
                }
            }
        }
        #else
        ConceptListView()
        #endif
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
