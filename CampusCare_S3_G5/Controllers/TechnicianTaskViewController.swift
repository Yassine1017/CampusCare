//
//  TechnicianTaskViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 08/12/2025.
//

import UIKit
import FirebaseFirestore

class TechnicianTaskViewController: UIViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var updatesLabel: UILabel!
    @IBOutlet weak var tasksTodayLabel: UILabel!
    @IBOutlet weak var tasksCompletedLabel: UILabel!
    @IBOutlet weak var tasksInProgressLabel: UILabel!
    @IBOutlet weak var highPriTaskLabel: UILabel!
    // MARK: - Properties
        var user: User?
        var tickets: [Ticket] = []
        private var listener: ListenerRegistration? // Store the listener to stop it when done
        private let db = Firestore.firestore()
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
                    
                    // Only fetch if a user was passed from Login
                    if let technicianID = user?.id {
                        fetchTechnicianTickets(technicianID: technicianID)
                    } else {
                        print("No technician user found, showing sample data")
                        setupSampleData()
                        updateUI()
                    }
        }
    deinit {
            listener?.remove()
        }
    
    // MARK: - Firestore Integration
        func fetchTechnicianTickets(technicianID: String) {
            // We query the 'tickets' collection for documents where 'assignedTo' matches this ID
            listener = db.collection("tickets")
                .whereField("assignedTo", isEqualTo: technicianID)
                .addSnapshotListener { [weak self] querySnapshot, error in
                    
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error fetching tickets: \(error.localizedDescription)")
                        return
                    }
                    
                    // Map Firestore documents to your Ticket model
                    self.tickets = querySnapshot?.documents.compactMap { document -> Ticket? in
                        try? document.data(as: Ticket.self)
                    } ?? []
                    
                    // Update the dashboard UI with live data
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
        }
    
        
        // MARK: - Setup
        func setupSampleData() {
            // Refactored: Initialize using the new User struct
            user = User(
                id: "13",
                firstName: "John",
                lastName: "Appleseed",
                email: "johndoe@test.com",
                role: .technician, // Using the new enum
                specialization: "IT Technician",
                createdAt: Timestamp(date: Date())
            )
            
            let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
            let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()

            let hvacTasks = [
                TicketTask(id: "t1", title: "Inspect classroom HVAC systems", status: .pending, priority: .high),
                TicketTask(id: "t2", title: "Clean cafeteria kitchen vents", status: .pending, priority: .high)
            ]

            tickets = [
                Ticket(id: "14", title: "HVAC Maintenance", dateCommenced: Date(), status: .new, priority: .high, tasks: hvacTasks, location: "Building A", issue: "Air flow", category: "Maintenance", description: "Routine check", assignedTo: "13", dueDate: futureDate),
                
                Ticket(id: "15", title: "Library Electrical", dateCommenced: Date(), status: .inProgress, priority: .medium, tasks: [], location: "Library", issue: "Flickering lights", category: "Electrical", description: "Standard repair", assignedTo: "13", dueDate: pastDate),
                
                Ticket(id: "16", title: "Server Room Setup", dateCommenced: pastDate, status: .completed, priority: .low, tasks: [], location: "Server Room", issue: "Installation", category: "IT", description: "Install new rack and cables.", assignedTo: "13", dueDate: Date())
            ]
        }
        
        func updateUI() {
            greetingLabel.text = getGreeting()
            
            let allTasks = tickets.flatMap { $0.tasks }
            
            let pendingCount = allTasks.filter { $0.status == .pending }.count
            let completedCount = allTasks.filter { $0.status == .completed }.count
            let inProgressCount = allTasks.filter { $0.status == .inProgress }.count
            let highPriorityCount = allTasks.filter { $0.priority == .high }.count
            
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
            
            // Refactored: Access name from User model
            if let user = user {
                return "\(greeting), \(user.firstName) \(user.lastName)!"
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
        
        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDashboard",
               let destinationVC = segue.destination as? TechnicianDashboardViewController {
                destinationVC.allTickets = self.tickets
            }
            
            if segue.identifier == "showStatistics",
               let destinationVC = segue.destination as? StatisticsViewController {
                // Refactored: Pass 'user' instead of 'technician'
                destinationVC.user = self.user
                destinationVC.tickets = self.tickets
            }
        }
}
