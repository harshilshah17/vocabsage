//
//  vocabsageApp.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

@main
struct vocabsageApp: App {
    let persistenceController = PersistenceController.shared
    @State private var showLoading = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Always render ContentView for proper first frame detection
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .opacity(showLoading ? 0 : 1)
                
                // Loading overlay
                if showLoading {
                    LoadingView()
                        .transition(.opacity)
                }
            }
            .task {
                // Show loading animation for 1.5 seconds
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                withAnimation(.easeInOut(duration: 0.5)) {
                    showLoading = false
                }
            }
        }
    }
}
