import UIKit

// 1. New independent data structure for this page
struct ActivityHistory {
    let requestTitle: String
    let completionDate: String
    let starRating: Int
    let comment: String
}

class FeedbackHistoryViewController: UITableViewController {

    // 2. Independent Test Data (This replaces the old Manager)
    // You can add more items here to test how the list looks
    var myHistory: [ActivityHistory] = [
        ActivityHistory(requestTitle: "AC Maintenance - Room 302", completionDate: "Dec 20, 2025", starRating: 5, comment: "The technician was very professional and fixed the issue quickly."),
        ActivityHistory(requestTitle: "Leaking Pipe - Kitchen", completionDate: "Dec 18, 2025", starRating: 4, comment: "Good service, but arrived 10 minutes late."),
        ActivityHistory(requestTitle: "Broken Window - Hallway", completionDate: "Dec 15, 2025", starRating: 5, comment: "Perfect job, cleaned up all the glass after finishing.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Activity History"
        
        // Customizing the TableView appearance
        tableView.tableFooterView = UIView() // Removes empty lines at the bottom
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Using Subtitle style to organize the 4 required features
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HistoryCell")
        let activity = myHistory[indexPath.row]
        
        // FEATURE: Request Title and Completion Date
        cell.textLabel?.text = "\(activity.requestTitle)"
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        
        // FEATURE: Star Rating and Comment and Date
        // We use string repeating to show actual stars based on the number
        let stars = String(repeating: "⭐", count: activity.starRating)
        
        let detailText = """
        Date: \(activity.completionDate)
        Rating: \(stars)
        Comment: \(activity.comment)
        """
        
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.numberOfLines = 0 // Allows the text to expand
        cell.detailTextLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.textColor = .darkGray
        
        // Adds a nice arrow on the right
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
