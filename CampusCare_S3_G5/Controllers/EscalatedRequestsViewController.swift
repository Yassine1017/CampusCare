import UIKit
import FirebaseFirestore

class EscalatedRequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // Optional if passed from Statistics Page later
    var technicianID: String?

    var escalatedTickets: [Ticket] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        fetchEscalatedTickets()
    }

    deinit {
        listener?.remove()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func fetchEscalatedTickets() {
        listener = db.collection("tickets")
            .whereField("isEscalated", isEqualTo: true)
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }

                if let error = error {
                    print("DEBUG: Firestore error: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("DEBUG: No escalated tickets found")
                    return
                }

                self.escalatedTickets = documents.compactMap { doc -> Ticket? in
                    do {
                        return try doc.data(as: Ticket.self)
                    } catch {
                        print("DEBUG: Ticket decode failed: \(error)")
                        return nil
                    }
                }

                print("DEBUG: Loaded \(self.escalatedTickets.count) escalated tickets")

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEscalatedDetail",
           let destinationVC = segue.destination as? DetailedEscalatedViewController,
           let ticket = sender as? Ticket {

            destinationVC.selectedTicket = ticket
        }
    }
    
}
extension EscalatedRequestsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return escalatedTickets.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TicketCell",
            for: indexPath
        ) as? TicketCell else {
            return UITableViewCell()
        }

        let ticket = escalatedTickets[indexPath.row]
        cell.configure(with: ticket)

        cell.onButtonTapped = { [weak self] in
            self?.performSegue(
                withIdentifier: "showEscalatedDetail",
                sender: ticket
            )
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

