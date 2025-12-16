//
//  MainTabView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI
import CoreData

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "brain.head.profile")
                }
                .tag(1)
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "square.grid.2x2")
                }
                .tag(2)
            
            YouView()
                .tabItem {
                    Label("You", systemImage: "person.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

