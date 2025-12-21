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
        var user: User?
        var tasks: [Task] = []
        
        // MARK: - Setup
        func setupSampleData() {
            // Sample user data
            user = User(firstName: "John", lastName: "Appleseed")
            
            // Sample tasks - Educational Campus Maintenance
            tasks = [
                Task(title: "Inspect classroom HVAC systems", status: .pending, priority: .high),
                Task(title: "Replace library light fixtures", status: .inProgress, priority: .medium),
                Task(title: "Clean science lab equipment", status: .pending, priority: .medium),
                Task(title: "Fix leaking roof in auditorium", status: .completed, priority: .high),
                Task(title: "Trim trees near walkways", status: .pending, priority: .low),
                Task(title: "Repair gymnasium flooring", status: .inProgress, priority: .high),
                Task(title: "Test emergency lighting systems", status: .completed, priority: .medium),
                Task(title: "Restock restroom supplies", status: .pending, priority: .low),
                Task(title: "Service campus shuttle buses", status: .inProgress, priority: .medium),
                Task(title: "Clean cafeteria kitchen vents", status: .pending, priority: .high),
                Task(title: "Inspect fire extinguishers", status: .completed, priority: .medium),
                Task(title: "Repair broken classroom desks", status: .pending, priority: .medium),
                Task(title: "Maintain athletic field irrigation", status: .inProgress, priority: .low),
                Task(title: "Update campus signage", status: .completed, priority: .low)
            ]
        }
        
        func updateUI() {
            // Update greeting
            greetingLabel.text = getGreeting()
            
            // Calculate task counts
            let pendingCount = tasks.filter { $0.status == .pending }.count
            let completedCount = tasks.filter { $0.status == .completed }.count
            let inProgressCount = tasks.filter { $0.status == .inProgress }.count
            let highPriorityCount = tasks.filter { $0.priority == .high }.count
            
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
            var greeting = ""
            
            switch hour {
            case 0..<12:
                greeting = "Good Morning"
            case 12..<17:
                greeting = "Good Afternoon"
            default:
                greeting = "Good Evening"
            }
            
            if let user = user {
                return "\(greeting), \(user.firstName) \(user.lastName)!"
            }
            return "\(greeting)!"
        }
        
        func getUpdateMessage(pendingCount: Int) -> String {
            if pendingCount > 0 {
                return "You have \(pendingCount) new tasks."
            } else {
                return "No new developments at the moment..."
            }
        }
        
        // MARK: - Actions (Optional - for refreshing data)
        @IBAction func refreshButtonTapped(_ sender: UIButton) {
            updateUI()
        }
    }

