import Foundation

// Keep this! Your FeedbackStats.swift uses 'Review'
struct Review {
    let rating: Int
    let comment: String
}

class FeedbackManager {
    static let shared = FeedbackManager()
    
    // We will use 'allReviews' as the master list for EVERYTHING
    var allReviews: [Review] = [
        Review(rating: 5, comment: "Initial sample feedback")
    ]
    
    private init() {}
}
