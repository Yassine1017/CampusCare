//
//  TechnicianDashboardViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 21/12/2025.
//

import UIKit

enum DashboardMode {
    case all
    case completed
    case escalated
}

class TechnicianDashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allTickets: [Ticket] = [] // Holds every ticket
    var displayedTickets: [Ticket] = []
    var viewMode: DashboardMode = .all // Use this instead of a simple Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if allTickets.isEmpty {
            generateSampleData()
        }
                
        applyFilters()
    }
    
    func setupTableView() {
            tableView.dataSource = self
            tableView.delegate = self
        }
    func applyFilters() {
            switch viewMode {
            case .completed:
                displayedTickets = allTickets.filter { $0.status == .completed }
                self.title = "Completed Requests"
            case .escalated:
                // Filters for tickets where the escalation flag is set to true
                displayedTickets = allTickets.filter { $0.isEscalated == true }
                self.title = "Escalated Requests"
            case .all:
                displayedTickets = allTickets
                self.title = "All Requests"
            }
            tableView.reloadData()
        }
        
        // MARK: - Creating Data (Updated Models)
    func generateSampleData() {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()

        let tasksForElevator = [
            TicketTask(id: "t1", title: "Inspect Cables", status: .completed, priority: .high),
            TicketTask(id: "t2", title: "Replace Fuse", status: .inProgress, priority: .high)
        ]

        let ticket1 = Ticket(
            id: "14",
            title: "Elevator Not Working",
            dateCommenced: Date(),
            status: .new,
            priority: .high,
            tasks: tasksForElevator,
            location: "Building A",
            issue: "Mechanical Failure",
            category: "Maintenance",
            description: "Main elevator in West Wing is stuck between floors.",
            assignedTo: "13",
            dueDate: tomorrow // Due soon
        )
        
        let ticket2 = Ticket(
            id: "15",
            title: "Door Lock Malfunction",
            dateCommenced: Date().addingTimeInterval(-86400),
            status: .inProgress,
            priority: .medium,
            tasks: [],
            location: "Building B",
            issue: "Electronic Lock",
            category: "Security",
            description: "Room 204 keypad not responding to student IDs.",
            assignedTo: "13",
            dueDate: yesterday // This will trigger the overdue warning in Detail View
        )
        
        let ticket3 = Ticket(
            id: "8",
            title: "Broken AC",
            dateCommenced: Date().addingTimeInterval(-172800),
            status: .onHold,
            priority: .low,
            tasks: [],
            location: "Lobby",
            issue: "Cooling System",
            category: "HVAC",
            description: "Unit making loud grinding noise.",
            assignedTo: "13",
            dueDate: Date(),
            isEscalated: true,
            escalationReason: "Parts on backorder for 3 weeks"
            
        )
        
        self.allTickets = [ticket1, ticket2, ticket3]
        tableView.reloadData()
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTicketDetail",
           let destinationVC = segue.destination as? DetailedRequestViewController,
           let ticket = sender as? Ticket {
            destinationVC.selectedTicket = ticket
        }
     }
    }

    // MARK: - TableView Data Source
    extension TechnicianDashboardViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return displayedTickets.count
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
                    return UITableViewCell()
                }
                let ticket = displayedTickets[indexPath.row]
                cell.configure(with: ticket)
                
                cell.onButtonTapped = { [weak self] in
                    self?.performSegue(withIdentifier: "showTicketDetail", sender: ticket)
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
