import UIKit

class FeedbackStats: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var totalReviewsLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    // Instead of fixed mock data, we pull from our Shared Manager
    var reviews: [Review] {
        return FeedbackManager.shared.allReviews
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        // Register a basic cell
        commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // This runs every time the screen appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh the calculations and the table list
        calculateStats()
        commentsTableView.reloadData()
    }
    
    func calculateStats() {
        // Handle case where there are no reviews yet to avoid crashing (dividing by zero)
        guard !reviews.isEmpty else {
            averageRatingLabel.text = "0.0"
            totalReviewsLabel.text = "No reviews yet"
            return
        }
        
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        let average = Double(totalRating) / Double(reviews.count)
        
        averageRatingLabel.text = String(format: "%.1f", average)
        totalReviewsLabel.text = "Based on \(reviews.count) reviews"
    }

    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Using subtitle style to show Rating on top and Comment below
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let review = reviews[indexPath.row]
        
        cell.textLabel?.text = "Rating: \(review.rating) Stars"
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        
        cell.detailTextLabel?.text = review.comment
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = .darkGray
        
        // Add a profile icon
        cell.imageView?.image = UIImage(systemName: "person.bubble.fill")
        cell.imageView?.tintColor = .systemBlue
        
        return cell
    }
}
