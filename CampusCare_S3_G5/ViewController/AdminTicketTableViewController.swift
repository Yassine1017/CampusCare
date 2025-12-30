import UIKit
import FirebaseFirestore

class AdminTicketTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    private var tickets: [Ticket] = []
    private var filteredTickets: [Ticket] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Maintenance Tickets"

        searchBar.delegate = self
        tableView.tableFooterView = UIView()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120

        loadTickets()
    }

    private func loadTickets() {
        Firestore.firestore()
            .collection("maintenanceTickets")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error = error {
                    print("Firestore error:", error)
                    return
                }

                self.tickets = snapshot?.documents.compactMap {
                    Ticket(firestoreData: $0.data(), documentID: $0.documentID)
                } ?? []

                self.filteredTickets = self.tickets.sorted {
                    $0.dateCommenced > $1.dateCommenced
                }

                self.tableView.reloadData()
            }
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        filteredTickets.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TicketCell",
            for: indexPath
        ) as! TicketTableViewCell

        cell.configure(with: filteredTickets[indexPath.row])
        return cell
    }

    // MARK: - Search

    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
        let text = text.lowercased()

        filteredTickets = text.isEmpty
            ? tickets
            : tickets.filter {
                $0.description.lowercased().contains(text) ||
                $0.status.rawValue.lowercased().contains(text) ||
                $0.id.lowercased().contains(text)
            }

        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
