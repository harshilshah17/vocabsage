//
//  Persistence.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Seed mock concepts for preview
        PersistenceController.seedMockConcepts(in: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "vocabsage")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Capture container to avoid capturing self in escaping closure
        let persistentContainer = container
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            // Seed mock data if database is empty (first launch)
            if !inMemory {
                // Perform on main thread since viewContext is main-queue concurrency type
                DispatchQueue.main.async {
                    let context = persistentContainer.viewContext
                    
                    // Check if database is empty
                    let fetchRequest: NSFetchRequest<Concept> = Concept.fetchRequest()
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let existingConcepts = try context.fetch(fetchRequest)
                        if existingConcepts.isEmpty {
                            // Database is empty, seed mock data
                            PersistenceController.seedMockConcepts(in: context)
                            
                            if context.hasChanges {
                                try context.save()
                                print("✅ Mock data seeded successfully - \(try context.count(for: Concept.fetchRequest())) concepts")
                            }
                        } else {
                            print("ℹ️ Database already contains \(try context.count(for: Concept.fetchRequest())) concepts")
                        }
                    } catch {
                        print("❌ Error checking/seeding mock data: \(error.localizedDescription)")
                    }
                }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
