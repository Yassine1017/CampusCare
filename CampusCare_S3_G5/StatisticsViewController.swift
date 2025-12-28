//
//  StatisticsViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-213-16 on 28/12/2025.
//

import UIKit

class StatisticsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var technicianNameAndIDLabel: UILabel!
    @IBOutlet weak var technicianPositionLabel: UILabel!
    @IBOutlet weak var totalCompletedLabel: UILabel!
    @IBOutlet weak var overallFeedbackLabel: UILabel!
    
    // MARK: - Properties
    var technician: Technician?
    var tickets: [Ticket] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        // 1. Display Technician Name and ID
        if let tech = technician {
            technicianNameAndIDLabel.text = "\(tech.firstName) \(tech.lastName) (#\(tech.id))"
            // Display Position/Specialization
            technicianPositionLabel.text = tech.specialization
        } else {
            // Fallback for placeholder
            technicianNameAndIDLabel.text = "Unknown Technician"
            technicianPositionLabel.text = "IT Technician"
        }
        
        // 2. Calculate Total Completed Requests
        // This filters the ticket array for those with a status of .completed
        let completedCount = tickets.filter { $0.status == .completed }.count
        totalCompletedLabel.text = "\(completedCount)"
        
        // 3. Overall Feedback Placeholder
        overallFeedbackLabel.text = "Mostly Positive"
    }
    
    @IBAction func viewCompletedRequestsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showCompletedRequests", sender: self)
    }

    @IBAction func viewEscalatedRequestsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showDashboardFiltered", sender: "escalated")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDashboardFiltered",
           let destinationVC = segue.destination as? TechnicianDashboardViewController {
            
            destinationVC.allTickets = self.tickets
            
            if let mode = sender as? String {
                destinationVC.viewMode = (mode == "escalated") ? .escalated : .completed
            }
        }
    }
}
