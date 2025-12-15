//
//  MockData.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import Foundation
import CoreData

struct ConceptMock {
    let id: UUID
    let title: String
    let summary: String
    let mentalModel: String
    let whyItExists: String
    let tradeoffs: String
    let gotchas: String
    let createdAt: Date
    let lastReviewedAt: Date?
}

extension PersistenceController {
    static func seedMockConcepts(in context: NSManagedObjectContext) {
        let mockConcepts: [ConceptMock] = [
            ConceptMock(
                id: UUID(),
                title: "Consistent Hashing",
                summary: "Distributes keys across nodes while minimizing reshuffling.",
                mentalModel: """
Imagine all servers placed on a ring. Each key hashes to a point on the ring and
belongs to the next server clockwise.
""",
                whyItExists: """
To avoid massive rebalancing when servers are added or removed.
""",
                tradeoffs: """
+ Minimal key movement
+ Scales well horizontally
- Requires virtual nodes for even distribution
""",
                gotchas: """
Naive implementations lead to hot spots.
Operational complexity increases with vnode tuning.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Backpressure",
                summary: "A mechanism to prevent producers from overwhelming consumers.",
                mentalModel: """
Think of traffic lights on a highway. Consumers signal when they are ready
to accept more work.
""",
                whyItExists: """
Without backpressure, fast producers can crash systems or cause cascading failures.
""",
                tradeoffs: """
+ Protects system stability
+ Improves predictability
- Adds latency
- Hard to tune correctly
""",
                gotchas: """
Ignoring backpressure signals leads to retry storms.
Often confused with rate limiting.
""",
                createdAt: Date(),
                lastReviewedAt: Date()
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Idempotency",
                summary: "Ensures repeated operations have the same effect.",
                mentalModel: """
Pressing an elevator button multiple times still results in one action.
""",
                whyItExists: """
Network retries are unavoidable. Idempotency prevents duplicated side effects.
""",
                tradeoffs: """
+ Safe retries
+ Simpler failure handling
- Requires careful state management
""",
                gotchas: """
Only applies to side effects, not performance.
Often incorrectly assumed to mean 'stateless'.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Eventual Consistency",
                summary: "Data converges over time rather than immediately.",
                mentalModel: """
Think of multiple clocks slowly syncing rather than staying perfectly aligned.
""",
                whyItExists: """
Strong consistency limits availability and scalability in distributed systems.
""",
                tradeoffs: """
+ High availability
+ Better partition tolerance
- Temporary inconsistency
- Complex reasoning
""",
                gotchas: """
Developers often underestimate user-facing inconsistency.
Requires careful conflict resolution.
""",
                createdAt: Date(),
                lastReviewedAt: Date()
            )
        ]
        
        for mock in mockConcepts {
            let concept = Concept(context: context)
            concept.id = mock.id
            concept.title = mock.title
            concept.summary = mock.summary
            concept.mentalModel = mock.mentalModel
            concept.whyItExists = mock.whyItExists
            concept.tradeoffs = mock.tradeoffs
            concept.gotchas = mock.gotchas
            concept.createdAt = mock.createdAt
            concept.lastReviewedAt = mock.lastReviewedAt
        }
    }
}

