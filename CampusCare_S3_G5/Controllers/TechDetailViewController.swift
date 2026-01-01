import UIKit
import FirebaseFirestore

class TechDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var solvedCountLabel: UILabel!
    @IBOutlet weak var averageStarLabel: UILabel!

    // MARK: - Properties
    var techUID: String?
    var techName: String?
    let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = techName ?? "Unknown Technician"
        calculateStats()
    }

    // MARK: - Logic
    func calculateStats() {
        guard let uid = techUID else { return }

        // Find feedback where technicianId matches the tech we clicked
        db.collection("feedbacks").whereField("technicianId", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let docs = snapshot?.documents else {
                self.updateUI(count: 0, avg: 0.0)
                return
            }

            let totalSolved = docs.count
            let ratings = docs.compactMap { $0.data()["rating"] as? Int }
            let average = totalSolved > 0 ? Double(ratings.reduce(0, +)) / Double(totalSolved) : 0.0

            self.updateUI(count: totalSolved, avg: average)
        }
    }
    
    private func updateUI(count: Int, avg: Double) {
        DispatchQueue.main.async {
            self.solvedCountLabel.text = "Tickets Solved: \(count)"
            self.averageStarLabel.text = String(format: "Average Rating: %.1f ⭐", avg)
        }
    }
}
