import UIKit
import FirebaseFirestore

class AdminRequestTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - IBOutlet
    // Only SearchBar should be connected (non-repeating content)
    @IBOutlet weak var SearchBar: UISearchBar!

    // MARK: - Data
    private var requests: [[String: Any]] = []
    private var filteredRequests: [[String: Any]] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Requests"

        SearchBar.delegate = self
        tableView.tableFooterView = UIView()

        loadRequestsFromFirebase()
    }

    // MARK: - Firebase
    private func loadRequestsFromFirebase() {
        let db = Firestore.firestore()

        db.collection("maintenanceTickets")
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }

                if let error = error {
                    print("Firestore error:", error)
                    return
                }

                guard let documents = snapshot?.documents else { return }

                // Store raw Firestore data (no FirestoreSwift)
                self.requests = documents.map { doc in
                    var data = doc.data()
                    data["id"] = doc.documentID
                    return data
                }

                self.filteredRequests = self.requests
                self.tableView.reloadData()
            }
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filteredRequests.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ContentRequestCell",
            for: indexPath
        )

        let request = filteredRequests[indexPath.row]

        // Basic display (cell UI handles labels internally if custom)
        cell.textLabel?.text = request["description"] as? String ?? "No Description"
        cell.detailTextLabel?.text = request["status"] as? String ?? "-"

        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredRequests = requests
        } else {
            filteredRequests = requests.filter {
                let description = ($0["description"] as? String ?? "").lowercased()
                let id = $0["id"] as? String ?? ""

                return description.contains(searchText.lowercased()) ||
                       id.contains(searchText)
            }
        }

        tableView.reloadData()
    }
}
