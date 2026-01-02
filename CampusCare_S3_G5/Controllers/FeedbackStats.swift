import UIKit
import FirebaseFirestore

class FeedbackStats: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var totalReviewsLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var feedbackList: [[String: Any]] = []
    let db = Firestore.firestore()
    
    var techID: String? // Received from TechnicianList
    var techName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = techName ?? "Performance"
        
        // Clear placeholder text immediately
        self.averageRatingLabel.text = "---"
        self.totalReviewsLabel.text = "Loading..."
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        fetchFeedbackFromFirestore()
    }
    
    func fetchFeedbackFromFirestore() {
        guard let idToFetch = techID else {
            print("No techID provided to Stats page")
            self.totalReviewsLabel.text = "No ID provided"
            return
        }

        // Search feedbacks for the technicianId matching the UID
        db.collection("feedbacks")
          .whereField("technicianId", isEqualTo: idToFetch)
          .getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Firebase Error: \(error.localizedDescription)")
                return
            }
            
            self.feedbackList.removeAll()
            var totalRatingSum = 0.0
            
            if let docs = snapshot?.documents, !docs.isEmpty {
                for document in docs {
                    let data = document.data()
                    self.feedbackList.append(data)
                    
                    let rating = data["rating"] as? Int ?? 0
                    totalRatingSum += Double(rating)
                }
                
                let count = self.feedbackList.count
                let average = totalRatingSum / Double(count)
                
                DispatchQueue.main.async {
                    self.averageRatingLabel.text = String(format: "%.1f", average)
                    self.totalReviewsLabel.text = "Based on \(count) reviews"
                    self.commentsTableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.averageRatingLabel.text = "0.0"
                    self.totalReviewsLabel.text = "No reviews found"
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell") ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: "StatsCell")
        
        let feedback = feedbackList[indexPath.row]
        let rating = feedback["rating"] as? Int ?? 0
        let comment = feedback["comment"] as? String ?? ""
        
        cell.textLabel?.text = String(repeating: "⭐", count: rating)
        cell.detailTextLabel?.text = comment
        return cell
    }
}
