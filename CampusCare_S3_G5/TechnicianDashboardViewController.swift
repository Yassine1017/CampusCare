//
//  TechnicianDashboardViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 21/12/2025.
//

import UIKit

class TechnicianDashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tickets: [Ticket] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        generateSampleData()
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        // Ensure this matches the ID you typed in Storyboard
        // If using a separate XIB, register it here.
        // If purely Storyboard prototype, just ensure the ID matches.
    }
    
    // MARK: - Creating Data (Tickets + Tasks)
    func generateSampleData() {
        // 1. Create some Tasks
        let tasksForElevator = [
            Task(title: "Inspect Cables", status: .completed, priority: .high),
            Task(title: "Replace Fuse", status: .inProgress, priority: .high),
            Task(title: "Final Safety Check", status: .pending, priority: .medium)
        ]
        
        let tasksForAC = [
            Task(title: "Clean Filter", status: .pending, priority: .low)
        ]
        
        // 2. Create Tickets containing those Tasks
        let ticket1 = Ticket(
            id: "14",
            title: "Elevator Not Working",
            dateCommenced: Date(),
            status: .open,
            priority: .critical,
            tasks: tasksForElevator, // <--- Tasks assigned here
            location: "Building A",
            assignedTo: "John Doe"
        )
        
        let ticket2 = Ticket(
            id: "15",
            title: "Door Lock Malfunction",
            dateCommenced: Date().addingTimeInterval(-86400), // Yesterday
            status: .inProgress,
            priority: .medium,
            tasks: [],
            location: "Building B",
            assignedTo: nil
        )
        
        let ticket3 = Ticket(
            id: "8",
            title: "Broken AC",
            dateCommenced: Date().addingTimeInterval(-172800), // 2 days ago
            status: .open,
            priority: .low,
            tasks: tasksForAC, // <--- Tasks assigned here
            location: "Lobby",
            assignedTo: "Jane Smith"
        )
        
        self.tickets = [ticket1, ticket2, ticket3]
        tableView.reloadData()
    }
    
}
// MARK: - TableView Data Source
extension TechnicianDashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
            return UITableViewCell()
        }
        
        let ticket = tickets[indexPath.row]
        cell.configure(with: ticket)
        
        cell.onButtonTapped = { [weak self] in
            print("Tapped ticket \(ticket.id)")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TechnicianDashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
}
