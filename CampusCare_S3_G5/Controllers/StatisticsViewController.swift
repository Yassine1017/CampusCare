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
        // Change this from 'technician' to 'user'
        var user: User?
        var tickets: [Ticket] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }

        private func setupUI() {
            // 1. Update Profile Info using the new User model
            if let user = user {
                technicianNameAndIDLabel.text = "\(user.firstName) \(user.lastName)"
                technicianPositionLabel.text = user.specialization ?? "General Technician"
            }

            // 2. Calculate Statistics from the tickets array
            let completedCount = tickets.filter { $0.status == .completed }.count
            let escalatedCount = tickets.filter { $0.isEscalated == true }.count

            totalCompletedLabel.text = "\(completedCount)"
        }

        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Ensure data is passed to the next filtered list views
            if segue.identifier == "showCompletedList",
               let destinationVC = segue.destination as? CompletedRequestsViewController {
                destinationVC.allTickets = self.tickets
            }
            
            if segue.identifier == "showEscalatedList",
               let destinationVC = segue.destination as? EscalatedRequestsViewController {
                destinationVC.allTickets = self.tickets
            }
        }
}
