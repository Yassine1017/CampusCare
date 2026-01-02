import UIKit
import FirebaseFirestore

class ManageTechniciansViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    // MARK: - Data
    private var technicians: [(id: String, name: String, email: String)] = []
    private var filteredTechnicians: [(id: String, name: String, email: String)] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Manage Technicians"

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        tableView.tableFooterView = UIView()

        loadTechnicians()
    }

    // MARK: - Firestore
    private func loadTechnicians() {
        Firestore.firestore()
            .collection("users")                              
            .whereField("role", isEqualTo: "technician")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Firestore error:", error)
                    return
                }

                self.technicians = snapshot?.documents.compactMap { doc in
                    let data = doc.data()

                    guard
                        let firstName = data["firstName"] as? String,
                        let lastName = data["lastName"] as? String,
                        let email = data["email"] as? String
                    else {
                        return nil
                    }

                    let fullName = "\(firstName) \(lastName)"
                    return (id: doc.documentID, name: fullName, email: email)
                } ?? []

                self.filteredTechnicians = self.technicians
                self.tableView.reloadData()
            }
    }

    // MARK: - Actions
    @IBAction func createButtonTapped(_ sender: UIButton) {
        print("Create New Technician tapped")
        // Navigation handled elsewhere
    }
}

// MARK: - TableView
extension ManageTechniciansViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTechnicians.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TechnicianCell", for: indexPath)

        let tech = filteredTechnicians[indexPath.row]
        cell.textLabel?.text = tech.name
        cell.detailTextLabel?.text = tech.email
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - Search
extension ManageTechniciansViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTechnicians = technicians
        } else {
            let lower = searchText.lowercased()
            filteredTechnicians = technicians.filter {
                $0.name.lowercased().contains(lower) ||
                $0.email.lowercased().contains(lower)
            }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
