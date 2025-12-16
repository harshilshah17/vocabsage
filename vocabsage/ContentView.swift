//
//  ContentView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        ConceptListView()
        #else
        MainTabView()
        #endif
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
