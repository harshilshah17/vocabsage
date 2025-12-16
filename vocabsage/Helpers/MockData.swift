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
            ),
            
            ConceptMock(
                id: UUID(),
                title: "CAP Theorem",
                summary: "You can only guarantee two of three: Consistency, Availability, Partition tolerance.",
                mentalModel: """
A triangle where you can pick any two corners, but never all three.
""",
                whyItExists: """
Fundamental constraint in distributed systems design.
""",
                tradeoffs: """
+ Helps make informed architectural decisions
+ Clear tradeoff framework
- Often oversimplified in practice
- Doesn't account for partial failures
""",
                gotchas: """
Partition tolerance is often non-negotiable in modern systems.
Consistency and availability are often treated as a spectrum, not binary.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Circuit Breaker",
                summary: "Prevents cascading failures by stopping requests to failing services.",
                mentalModel: """
Like an electrical circuit breaker: trips when overloaded, prevents damage.
""",
                whyItExists: """
Fast failure is better than slow failure. Protects downstream services.
""",
                tradeoffs: """
+ Prevents cascading failures
+ Fails fast
- Can cause false positives
- Requires careful tuning
""",
                gotchas: """
Half-open state is tricky to implement correctly.
Must distinguish between transient and permanent failures.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Bloom Filter",
                summary: "Probabilistic data structure for membership testing.",
                mentalModel: """
A hash table that can say "definitely not here" or "probably here".
""",
                whyItExists: """
Space-efficient way to check if something might be in a set.
""",
                tradeoffs: """
+ Extremely memory efficient
+ Fast lookups
- False positives possible
- No deletion without counting variant
""",
                gotchas: """
False positive rate increases with more elements.
Cannot retrieve the actual items, only check membership.
""",
                createdAt: Date(),
                lastReviewedAt: Date()
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Rate Limiting",
                summary: "Controls the rate of requests to prevent abuse and overload.",
                mentalModel: """
A bouncer at a club checking how many people enter per minute.
""",
                whyItExists: """
Protects services from being overwhelmed and prevents abuse.
""",
                tradeoffs: """
+ Prevents DDoS attacks
+ Ensures fair resource usage
- Can block legitimate users
- Complex to implement globally
""",
                gotchas: """
Distributed rate limiting requires coordination.
Token bucket vs sliding window have different behaviors.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Leader Election",
                summary: "Process of selecting a single node to coordinate actions.",
                mentalModel: """
Like choosing a team captain: one person makes decisions for the group.
""",
                whyItExists: """
Avoids split-brain scenarios in distributed systems.
""",
                tradeoffs: """
+ Prevents conflicts
+ Simplifies coordination
- Single point of failure
- Requires re-election on leader failure
""",
                gotchas: """
Split-brain can occur if network partitions aren't handled correctly.
Election storms can happen if multiple nodes think they're the leader.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "ACID Properties",
                summary: "Atomicity, Consistency, Isolation, Durability - guarantees for database transactions.",
                mentalModel: """
Four pillars that ensure database transactions are reliable.
""",
                whyItExists: """
Ensures data integrity and reliability in database operations.
""",
                tradeoffs: """
+ Strong guarantees
+ Predictable behavior
- Performance overhead
- Can limit scalability
""",
                gotchas: """
Isolation levels trade off consistency for performance.
ACID doesn't guarantee correctness, only reliability.
""",
                createdAt: Date(),
                lastReviewedAt: Date()
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Pub/Sub Pattern",
                summary: "Messaging pattern where publishers send messages without knowing subscribers.",
                mentalModel: """
Like a radio station: broadcasts without knowing who's listening.
""",
                whyItExists: """
Decouples producers and consumers, enables scalable event-driven architectures.
""",
                tradeoffs: """
+ Loose coupling
+ Scalable
- Eventual delivery guarantees
- Harder to debug
""",
                gotchas: """
Message ordering isn't guaranteed across partitions.
Subscribers must handle duplicate messages.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Database Indexing",
                summary: "Data structure that improves query performance at the cost of write speed.",
                mentalModel: """
Like an index in a book: helps you find pages quickly.
""",
                whyItExists: """
Makes queries faster without scanning entire tables.
""",
                tradeoffs: """
+ Faster reads
+ Enables unique constraints
- Slower writes
- Additional storage
""",
                gotchas: """
Too many indexes can slow down writes significantly.
Index selection requires understanding query patterns.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Load Balancing",
                summary: "Distributes incoming requests across multiple servers.",
                mentalModel: """
Like a traffic director routing cars to different lanes.
""",
                whyItExists: """
Improves availability, throughput, and prevents overload.
""",
                tradeoffs: """
+ High availability
+ Better resource utilization
- Adds complexity
- Can introduce latency
""",
                gotchas: """
Session affinity can break if not handled correctly.
Health checks must be fast to avoid routing to dead servers.
""",
                createdAt: Date(),
                lastReviewedAt: Date()
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Caching",
                summary: "Storing frequently accessed data in fast storage for quick retrieval.",
                mentalModel: """
Like keeping your keys by the door instead of searching the whole house.
""",
                whyItExists: """
Reduces latency and load on primary data sources.
""",
                tradeoffs: """
+ Much faster reads
+ Reduces backend load
- Stale data risk
- Memory overhead
""",
                gotchas: """
Cache invalidation is one of the hardest problems in CS.
Cache stampede can overwhelm backend when cache expires.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Quorum",
                summary: "Minimum number of nodes that must agree for an operation to proceed.",
                mentalModel: """
Like voting: need majority to make a decision.
""",
                whyItExists: """
Ensures consistency in distributed systems despite node failures.
""",
                tradeoffs: """
+ Tolerates failures
+ Maintains consistency
- Requires majority of nodes
- Can block during partitions
""",
                gotchas: """
Split-brain occurs if quorum isn't properly enforced.
Network partitions can make system unavailable.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Exponential Backoff",
                summary: "Retry strategy that increases wait time between attempts exponentially.",
                mentalModel: """
Like waiting longer each time before knocking on a door.
""",
                whyItExists: """
Prevents overwhelming a failing service with retry requests.
""",
                tradeoffs: """
+ Reduces load on failing service
+ Handles transient failures
- Slower recovery
- Can delay detection of permanent failures
""",
                gotchas: """
Jitter should be added to prevent thundering herd.
Maximum retry limit prevents infinite retries.
""",
                createdAt: Date(),
                lastReviewedAt: Date()
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Sharding",
                summary: "Partitioning data across multiple databases or servers.",
                mentalModel: """
Like splitting a large library into multiple smaller libraries by topic.
""",
                whyItExists: """
Enables horizontal scaling beyond single machine limits.
""",
                tradeoffs: """
+ Scales horizontally
+ Improves performance
- Complex to implement
- Cross-shard queries are expensive
""",
                gotchas: """
Rebalancing shards is operationally complex.
Hot shards can become bottlenecks.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            ),
            
            ConceptMock(
                id: UUID(),
                title: "Message Queue",
                summary: "Asynchronous communication pattern using a queue for messages.",
                mentalModel: """
Like a post office: messages wait in line to be processed.
""",
                whyItExists: """
Decouples producers and consumers, handles traffic spikes.
""",
                tradeoffs: """
+ Decouples services
+ Handles bursts
- Eventual consistency
- Requires monitoring
""",
                gotchas: """
Poison messages can block queues.
Message ordering isn't guaranteed across partitions.
""",
                createdAt: Date(),
                lastReviewedAt: nil
            )
        ]
        
        for mock in mockConcepts {
            let concept = Concept(context: context)
            concept.id = mock.id
            // Mark as example content
            concept.title = "[Example] \(mock.title)"
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

