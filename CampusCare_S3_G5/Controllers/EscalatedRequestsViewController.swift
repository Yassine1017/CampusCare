//
//  EscalatedRequestsViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-18 on 28/12/2025.
//


import UIKit

class EscalatedRequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Received from Statistics Page
    var allTickets: [Ticket] = []
    var escalatedTickets: [Ticket] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        filterEscalatedData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func filterEscalatedData() {
        // Only show tickets where isEscalated is true
        escalatedTickets = allTickets.filter { $0.isEscalated == true }
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEscalatedDetail",
           let destinationVC = segue.destination as? DetailedEscalatedViewController,
           let ticket = sender as? Ticket {
            destinationVC.selectedTicket = ticket
        }
    }
}

// MARK: - TableView Methods
extension EscalatedRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return escalatedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
            return UITableViewCell()
        }
        
        let ticket = escalatedTickets[indexPath.row]
        cell.configure(with: ticket)
        
        cell.onButtonTapped = { [weak self] in
            self?.performSegue(withIdentifier: "showEscalatedDetail", sender: ticket)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
