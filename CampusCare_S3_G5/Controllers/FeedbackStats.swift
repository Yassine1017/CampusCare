import UIKit
import FirebaseFirestore

// 1. Model to hold the data coming from Firebase
struct Feedback {
    let rating: Int
    let comment: String
    let date: String
}

class FeedbackStats: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets (Connected to your Storyboard)
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var totalReviewsLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    // MARK: - Variables
    var feedbackList: [Feedback] = []
    let db = Firestore.firestore()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        // Fetch data immediately when screen loads
        fetchFeedbackFromFirestore()
    }
    
    // MARK: - Firestore Data Fetching
    func fetchFeedbackFromFirestore() {
        // 1. Go to the "feedbacks" collection in your database
        db.collection("feedbacks").order(by: "date", descending: true).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            // 2. Clear old list
            self.feedbackList.removeAll()
            var totalRatingSum = 0.0
            
            // 3. Loop through every document found
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    // Safely extract data (if missing, use defaults)
                    let rating = data["rating"] as? Int ?? 0
                    let comment = data["comment"] as? String ?? "No comment"
                    
                    // Handle Date (It might be a Timestamp or a String)
                    var dateString = ""
                    if let timestamp = data["date"] as? Timestamp {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        dateString = formatter.string(from: timestamp.dateValue())
                    } else {
                        dateString = data["date"] as? String ?? ""
                    }
                    
                    // Add to our list
                    let newFeedback = Feedback(rating: rating, comment: comment, date: dateString)
                    self.feedbackList.append(newFeedback)
                    
                    // Add to sum for calculation
                    totalRatingSum += Double(rating)
                }
                
                // 4. Update the UI with the calculations
                self.updateStatsUI(totalSum: totalRatingSum, count: self.feedbackList.count)
                
                // 5. Refresh the list
                self.commentsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Update UI Helper
    func updateStatsUI(totalSum: Double, count: Int) {
        if count > 0 {
            let average = totalSum / Double(count)
            // Format to 1 decimal place (e.g., "4.5")
            averageRatingLabel.text = String(format: "%.1f / 5.0", average)
            totalReviewsLabel.text = "Based on \(count) reviews"
        } else {
            averageRatingLabel.text = "0.0 / 5.0"
            totalReviewsLabel.text = "No reviews yet"
        }
    }

    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a standard cell (Subtitle style shows text below title)
        var cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StatsCell")
        }
        
        let feedback = feedbackList[indexPath.row]
        
        // Convert number to Star Emojis
        let stars = String(repeating: "⭐", count: feedback.rating)
        
        cell?.textLabel?.text = stars
        cell?.detailTextLabel?.text = "\(feedback.comment)"
        cell?.detailTextLabel?.numberOfLines = 0 // Allow multiline comments
        
        return cell!
    }
}
