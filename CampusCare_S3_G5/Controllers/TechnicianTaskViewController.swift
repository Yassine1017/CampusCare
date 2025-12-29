//
//  TechnicianTaskViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 08/12/2025.
//

import UIKit

class TechnicianTaskViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSampleData()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var updatesLabel: UILabel!
    @IBOutlet weak var tasksTodayLabel: UILabel!
    @IBOutlet weak var tasksCompletedLabel: UILabel!
    @IBOutlet weak var tasksInProgressLabel: UILabel!
    @IBOutlet weak var highPriTaskLabel: UILabel!
    // MARK: - Properties
    var technician: Technician?
    var tickets: [Ticket] = []
    
    // MARK: - Setup
    func setupSampleData() {
        technician = Technician(id: "13", firstName: "John", lastName: "Appleseed", email: "johndoe@test.com", specialization: "IT Technician", phone: "399")
        
        // Create dates for testing: one in the future, one in the past
        let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()

        let hvacTasks = [
            TicketTask(id: "t1", title: "Inspect classroom HVAC systems", status: .pending, priority: .high),
            TicketTask(id: "t2", title: "Clean cafeteria kitchen vents", status: .pending, priority: .high)
        ]

        tickets = [
                // Ticket 1: New/Active
                Ticket(id: "14", title: "HVAC Maintenance", dateCommenced: Date(), status: .new, priority: .high, tasks: hvacTasks, location: "Building A", issue: "Air flow", category: "Maintenance", description: "Routine check", assignedTo: "13", dueDate: futureDate),
                
                // Ticket 2: In Progress/Overdue
                Ticket(id: "15", title: "Library Electrical", dateCommenced: Date(), status: .inProgress, priority: .medium, tasks: [], location: "Library", issue: "Flickering lights", category: "Electrical", description: "Standard repair", assignedTo: "13", dueDate: pastDate),
                
                // NEW Ticket 3: Completed (To test the "View Completed" button)
                Ticket(id: "16", title: "Server Room Setup", dateCommenced: pastDate, status: .completed, priority: .low, tasks: [], location: "Server Room", issue: "Installation", category: "IT", description: "Install new rack and cables.", assignedTo: "13", dueDate: Date())
            ]
    }
    
    func updateUI() {
        // Update greeting
        greetingLabel.text = getGreeting()
        
        // Flatten all tasks from all tickets into one array for calculation
        let allTasks = tickets.flatMap { $0.tasks }
        
        // Calculate task counts from the flattened array
        let pendingCount = allTasks.filter { $0.status == .pending }.count
        let completedCount = allTasks.filter { $0.status == .completed }.count
        let inProgressCount = allTasks.filter { $0.status == .inProgress }.count
        let highPriorityCount = allTasks.filter { $0.priority == .high }.count
        
        // Update labels with counts
        updatesLabel.text = getUpdateMessage(pendingCount: pendingCount)
        tasksTodayLabel.text = "Tasks Pending Today: \(pendingCount)"
        tasksCompletedLabel.text = "Tasks Completed: \(completedCount)"
        tasksInProgressLabel.text = "Tasks In Progress: \(inProgressCount)"
        highPriTaskLabel.text = "High Priority Tasks: \(highPriorityCount)"
    }
    
    // MARK: - Helper Methods
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        
        switch hour {
        case 0..<12: greeting = "Good Morning"
        case 12..<17: greeting = "Good Afternoon"
        default: greeting = "Good Evening"
        }
        
        if let technician = technician {
            return "\(greeting), \(technician.firstName) \(technician.lastName)!"
        }
        return "\(greeting)!"
    }
    
    func getUpdateMessage(pendingCount: Int) -> String {
        return pendingCount > 0 ? "You have \(pendingCount) new tasks." : "No new developments at the moment..."
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. Fixing the main Requests button
        if segue.identifier == "showDashboard",
           let destinationVC = segue.destination as? TechnicianDashboardViewController {
            // Only pass the data. The Dashboard will handle showing everything.
            destinationVC.allTickets = self.tickets
            print("DEBUG: Sending \(self.tickets.count) tickets to main Dashboard")
        }
        
        // 2. Statistics Page bridge
        if segue.identifier == "showStatistics",
           let destinationVC = segue.destination as? StatisticsViewController {
            destinationVC.technician = self.technician
            destinationVC.tickets = self.tickets
        }
    }
}
