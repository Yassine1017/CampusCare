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

    /// Logged-in user (technician role expected)
    var user: User?

    /// Tickets assigned to the technician
    var tickets: [Ticket] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - UI Updates

    private func updateUI() {

        // 1. Technician identity (from User model)
        if let user = user, user.role == .technician {
            technicianNameAndIDLabel.text =
                "\(user.firstName) \(user.lastName) (#\(user.id))"

            technicianPositionLabel.text =
                user.specialization ?? "IT Technician"
        } else {
            // Fallback if user is nil or not a technician
            technicianNameAndIDLabel.text = "Technician"
            technicianPositionLabel.text = ""
        }

        // 2. Total completed tickets
        let completedCount = tickets.filter { $0.status == .completed }.count
        totalCompletedLabel.text = "\(completedCount)"

        // 3. Overall feedback (placeholder)
        overallFeedbackLabel.text = "Mostly Positive"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showCompletedList",
           let destinationVC = segue.destination as? CompletedRequestsViewController {

            destinationVC.allTickets = tickets
        }

        if segue.identifier == "showEscalatedList",
           let destinationVC = segue.destination as? EscalatedRequestsViewController {

            destinationVC.allTickets = tickets
        }
    }
}
