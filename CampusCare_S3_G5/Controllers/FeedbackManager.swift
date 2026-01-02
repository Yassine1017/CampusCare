import Foundation
import FirebaseFirestore

// 1. Defining this here makes 'Review' visible to all other files
struct Review {
    let rating: Int
    let comment: String
    let date: Date
    let ticketId: String
    let technicianId: String
}

class FeedbackManager {
    static let shared = FeedbackManager()
    
    // Holds the list of reviews fetched from Firebase
    var allReviews: [Review] = []
    
    private init() {}

    // Helper to insert new feedback locally for immediate UI updates
    func addReview(_ review: Review) {
        allReviews.insert(review, at: 0)
    }

    // Fetches all feedback from the "feedbacks" collection
    func syncWithFirestore(completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("feedbacks").order(by: "date", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error syncing: \(error)")
                completion(false)
                return
            }
            
            self.allReviews = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return Review(
                    rating: data["rating"] as? Int ?? 0,
                    comment: data["comment"] as? String ?? "",
                    date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                    // Supports both 'requestId' and 'ticketId' field names
                    ticketId: data["ticketId"] as? String ?? data["requestId"] as? String ?? "N/A",
                    technicianId: data["technicianId"] as? String ?? "Staff"
                )
            } ?? []
            completion(true)
        }
    }
}
