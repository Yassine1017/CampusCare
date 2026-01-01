import UIKit

class FeedbackHistoryViewController: UITableViewController, FeedbackDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Feedbacks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // FIXED: Removed the parameter to match the protocol in FeedBackRating.swift
    func didSubmitNewFeedback() {
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedbackManager.shared.allReviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let data = FeedbackManager.shared.allReviews[indexPath.row]
        let stars = String(repeating: "⭐", count: data.rating)
        
        cell.textLabel?.text = "Rating: \(stars)"
        cell.detailTextLabel?.text = data.comment
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
}
