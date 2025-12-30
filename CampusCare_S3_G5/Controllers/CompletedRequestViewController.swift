//
//  CompletedRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-18 on 28/12/2025.
//

import UIKit

class CompletedRequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // This will be passed from the Statistics Page
    var allTickets: [Ticket] = []
    var completedTickets: [Ticket] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        filterData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func filterData() {
        // Hard-coded to only show completed
        completedTickets = allTickets.filter { $0.status == .completed }
        print("Completed View: Found \(completedTickets.count) tickets")
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCompletedDetail",
           let destinationVC = segue.destination as? DetailedCompletedViewController,
           let ticket = sender as? Ticket {
            // This line MUST execute to pass the data
            destinationVC.selectedTicket = ticket
            print("DEBUG: Successfully passed ticket #\(ticket.id) to Detail View")
        }
    }

}

// MARK: - TableView Methods
extension CompletedRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
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
