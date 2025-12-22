import Foundation

// The data model
struct Review {
    let rating: Int
    let comment: String
}

// The Manager that holds the "Collection"
class FeedbackManager {
    static let shared = FeedbackManager() // This makes it accessible everywhere
    
    var allReviews: [Review] = []
    
    private init() {} // Prevents creating multiple copies
}
