import Foundation

struct UserFeedback {
    let requestTitle: String
    let completionDate: String
    let starRating: Int
    let comment: String
}

// This is a simple local storage for your testing
struct FeedbackStore {
    static var history: [UserFeedback] = [
        UserFeedback(requestTitle: "AC Repair - Room 101", completionDate: "2025-12-20", starRating: 5, comment: "Excellent service, very fast!"),
        UserFeedback(requestTitle: "Plumbing - Building B", completionDate: "2025-12-22", starRating: 3, comment: "Fixed the leak but left a bit of a mess.")
    ]
}
