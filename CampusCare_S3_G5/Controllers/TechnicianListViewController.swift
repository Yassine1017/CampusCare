import UIKit
import FirebaseFirestore

class TechnicianListViewController: UITableViewController {
    
    var technicians: [[String: Any]] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Technicians"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TechCell")
        fetchTechnicians()
    }
    
    // Replace your fetchTechnicians function with this:
    func fetchTechnicians() {
        db.collection("users").whereField("role", isEqualTo: "technician").getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let docs = snapshot?.documents else { return }
            
            // FIXED: This map now includes the Document ID as "id"
            self.technicians = docs.map { doc in
                var data = doc.data()
                data["id"] = doc.documentID // This captures the real Firebase UID
                return data
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return technicians.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TechCell")
        let tech = technicians[indexPath.row]
        let fullName = "\(tech["firstName"] ?? "") \(tech["lastName"] ?? "")"
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = tech["email"] as? String ?? ""
        return cell
    }
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tech = technicians[indexPath.row]
        
        // Combine names
        let first = tech["firstName"] as? String ?? ""
        let last = tech["lastName"] as? String ?? ""
        let fullName = "\(first) \(last)"
        
        // 1. Reference the "FeedbackStats" storyboard
        let storyboard = UIStoryboard(name: "FeedbackStats", bundle: nil)
        
        // 2. Instantiate the FeedbackStats controller using its Storyboard ID
        if let statsVC = storyboard.instantiateViewController(withIdentifier: "FeedbackStatsVC") as? FeedbackStats {
            
            // 3. THE CRITICAL FIX: Pass the UID from your "users" collection.
            // This replaces "No ID provided" with the actual ID like "Vz9kt..."
            statsVC.techID = tech["id"] as? String
            statsVC.techName = fullName
            
            // 4. Push to the performance page
            self.navigationController?.pushViewController(statsVC, animated: true)
        }
    }
}
