//
//  CompletedRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-18 on 28/12/2025.
//

import UIKit
import FirebaseFirestore

class CompletedRequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // This will be passed from the Statistics Page
    var technicianID: String?
        
        var allTickets: [Ticket] = []
        var completedTickets: [Ticket] = []
        
        private let db = Firestore.firestore()
        private var listener: ListenerRegistration?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCompletedDetail" {
            guard let destinationVC = segue.destination as? DetailedCompletedViewController,
                  let ticket = sender as? Ticket else {
                print("DEBUG: Segue failed - could not cast destination or ticket")
                return
            }
            
            // This is the critical line: Injecting the ticket into the detail view
            destinationVC.selectedTicket = ticket
            print("DEBUG: Successfully passed ticket #\(ticket.id) to DetailedCompletedViewController")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
                
        print("DEBUG: technicianID is \(technicianID ?? "NIL")") // Check this in console
                    
            if let id = technicianID {
                fetchCompletedTickets(for: id)
            }
    }
    deinit {
            listener?.remove()
        }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchCompletedTickets(for id: String) {
        listener = db.collection("tickets")
                .whereField("assignedTo", isEqualTo: id)
                .whereField("status", isEqualTo: "Completed") // Ensure this matches DB case!
                .addSnapshotListener { [weak self] querySnapshot, error in
                    
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("DEBUG: Firebase Error - \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("DEBUG: No documents found")
                        return
                    }
                    
                    self.completedTickets = documents.compactMap { document -> Ticket? in
                        do {
                            return try document.data(as: Ticket.self)
                        } catch {
                            print("DEBUG: Decoding error for ticket \(document.documentID): \(error)")
                            return nil
                        }
                    }
                    
                    print("DEBUG: Successfully loaded \(self.completedTickets.count) tickets")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }

}

// MARK: - TableView Methods
extension CompletedRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("DEBUG: Drawing row \(indexPath.row) for ticket #\(completedTickets[indexPath.row].id)")
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
                print("DEBUG: Failed to cast cell to TicketCell. Check Storyboard Identity Inspector.")
                return UITableViewCell()
            }
            
            let ticket = completedTickets[indexPath.row]
            cell.configure(with: ticket)
            
            cell.onButtonTapped = { [weak self] in
                self?.performSegue(withIdentifier: "showCompletedDetail", sender: ticket)
            }
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
