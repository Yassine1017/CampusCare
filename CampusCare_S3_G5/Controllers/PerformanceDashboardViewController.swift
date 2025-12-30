import UIKit
import FirebaseFirestore

class PerformanceDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var topSolvedNameLabel: UILabel!
    @IBOutlet weak var topSolvedCountLabel: UILabel!
    
    @IBOutlet weak var topRatedNameLabel: UILabel!
    @IBOutlet weak var topRatedRatingLabel: UILabel!

    private let db = Firestore.firestore()
    
    var allTechnicians: [TechData] = []
    var filteredTechs: [TechData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Technical Performance"
        
        // Safety check to prevent crashing if a connection is missed
        guard tableView != nil, searchBar != nil else {
            print("❌ Error: Outlets not connected properly in Storyboard")
            return
        }

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TechCell")
        
        fetchDataFromFirebase()
    }

    private func fetchDataFromFirebase() {
        db.collection("users").whereField("role", isEqualTo: "Tech").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let group = DispatchGroup()
            var tempTechs: [TechData] = []

            for doc in documents {
                let name = doc.data()["name"] as? String ?? "Unknown"
                let specialty = doc.data()["specialty"] as? String ?? "General"
                let userId = doc.documentID
                
                group.enter()
                self.db.collection("feedbacks").whereField("userId", isEqualTo: userId).getDocuments { (fSnapshot, _) in
                    let feedbackDocs = fSnapshot?.documents ?? []
                    let totalDone = feedbackDocs.count
                    let totalRating = feedbackDocs.reduce(0.0) { $0 + (Double($1.data()["rating"] as? Int ?? 0)) }
                    let avgRating = totalDone > 0 ? (totalRating / Double(totalDone)) : 0.0
                    
                    let tech = TechData(
                        name: name,
                        averageRating: avgRating,
                        totalCompleted: totalDone,
                        avgResolutionTime: "1.5h",
                        specialty: specialty
                    )
                    tempTechs.append(tech)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.allTechnicians = tempTechs
                self.filteredTechs = self.allTechnicians
                self.tableView.reloadData()
                self.updateHighlightStats() // This fills your grey/green boxes
            }
        }
    }

    private func updateHighlightStats() {
        // Grey Box: Most Tickets
        if let topSolved = allTechnicians.max(by: { $0.totalCompleted < $1.totalCompleted }) {
            topSolvedNameLabel.text = topSolved.name
            topSolvedCountLabel.text = "\(topSolved.totalCompleted) Tickets"
        }
        
        // Green Box: Best Rating
        if let topRated = allTechnicians.max(by: { $0.averageRating < $1.averageRating }) {
            topRatedNameLabel.text = topRated.name
            topRatedRatingLabel.text = String(format: "⭐ %.1f", topRated.averageRating)
        }
    }

    // MARK: - Search Bar & TableView Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTechs = searchText.isEmpty ? allTechnicians : allTechnicians.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.specialty.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTechs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TechCell")
        let tech = filteredTechs[indexPath.row]
        cell.textLabel?.text = "\(tech.name) - \(tech.specialty)"
        cell.detailTextLabel?.text = "Rating: ⭐\(String(format: "%.1f", tech.averageRating)) | Done: \(tech.totalCompleted)"
        return cell
    }
}
