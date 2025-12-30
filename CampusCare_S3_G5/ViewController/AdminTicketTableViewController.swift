import UIKit
import FirebaseFirestore

class AdminTicketTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    private var tickets: [Ticket] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tickets"

        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        loadTickets()
    }

    private func loadTickets() {
        Firestore.firestore()
            .collection("tickets") // <-- matches your Firestore
            .order(by: "dateCommenced", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error = error {
                    print("Firestore error:", error)
                    return
                }

                self.tickets = snapshot?.documents.compactMap { doc in
                    let data = doc.data()

                    // Required fields (must exist)
                    guard
                        let title = data["title"] as? String,
                        let issue = data["issue"] as? String,
                        let location = data["location"] as? String,
                        let description = data["description"] as? String,
                        let category = data["category"] as? String,
                        let statusRaw = data["status"] as? String,
                        let status = TicketStatus(rawValue: statusRaw),
                        let priorityRaw = data["priority"] as? String,
                        let priority = TicketPriority(rawValue: priorityRaw),
                        let dateTS = data["dateCommenced"] as? Timestamp,
                        let dueTS = data["dueDate"] as? Timestamp
                    else {
                        print("⚠️ Skipping invalid ticket:", doc.documentID)
                        return nil
                    }

                    // SAFE DEFAULTS (Firestore currently has no tasks)
                    let tasks: [TicketTask] = []

                    return Ticket(
                        id: doc.documentID,
                        title: title,
                        dateCommenced: dateTS.dateValue(),
                        status: status,
                        priority: priority,
                        tasks: tasks,
                        location: location,
                        issue: issue,
                        category: category,
                        description: description,
                        assignedTo: data["assignedTo"] as? String,
                        dueDate: dueTS.dateValue(),
                        isEscalated: data["isEscalated"] as? Bool ?? false,
                        escalationReason: data["escalationReason"] as? String
                    )
                } ?? []

                print("✅ Loaded tickets:", self.tickets.count)
                self.tableView.reloadData()
            }
    }

    // MARK: - Table Data Source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        tickets.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TicketCell",
            for: indexPath
        ) as! TicketTableViewCell

        cell.configure(with: tickets[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedTicket = tickets[indexPath.row]

        guard let detailVC = storyboard?.instantiateViewController(
            withIdentifier: "TicketDetailViewController"
        ) as? TicketDetailViewController else {
            print("Detail VC not found in storyboard")
            return
        }

        detailVC.ticket = selectedTicket
        navigationController?.pushViewController(detailVC, animated: true)
    }

}


