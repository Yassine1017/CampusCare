import UIKit

// 1. We added 'FeedbackDelegate' here.
// This fixes the error: "Cannot assign value... to type 'FeedbackDelegate'"
class FeedbackHistoryViewController: UITableViewController, FeedbackDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Feedbacks"
        
        // This ensures the table view uses the identifier you set in Storyboard
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // 2. This is the REQUIRED function for the FeedbackDelegate.
    // When the user clicks "Submit" on the rating page, this code runs.
    func didSubmitNewFeedback(_ activity: ActivityHistory) {
        // We take the data from the 'ActivityHistory' and save it into our 'allReviews' list
        let newReview = Review(rating: activity.starRating, comment: activity.comment)
        FeedbackManager.shared.allReviews.insert(newReview, at: 0)
        
        // Refresh the UI to show the new comment immediately
        tableView.reloadData()
    }

    // Refresh the list every time the screen appears (e.g., coming back from the rating page)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table View Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Safe: Pulls from the manager you already created
        return FeedbackManager.shared.allReviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // We create the cell with a 'subtitle' style to show stars on top and comment below
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let data = FeedbackManager.shared.allReviews[indexPath.row]
        
        // Convert the number (1-5) into star emojis
        let stars = String(repeating: "⭐", count: data.rating)
        
        cell.textLabel?.text = "Rating: \(stars)"
        cell.detailTextLabel?.text = data.comment
        cell.detailTextLabel?.numberOfLines = 0 // Allows long comments to wrap to the next line
        
        return cell
    }
}
