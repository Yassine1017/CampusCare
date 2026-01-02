//
//  DetailedCompletedViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-18 on 28/12/2025.
//


import UIKit

class DetailedCompletedViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var maintenanceIDLabel: UILabel!
    @IBOutlet weak var dateStartedLabel: UILabel!
    @IBOutlet weak var completedAtLabel: UILabel!
    @IBOutlet weak var priorityLevelLabel: UILabel!
    @IBOutlet weak var userFeedbackLabel: UILabel!

    // MARK: - Properties
    var selectedTicket: Ticket?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        guard let ticket = selectedTicket else { return }

            // 1. Core Information
            descriptionTextView.text = ticket.description
            maintenanceIDLabel.text = "Maintenance ID: #\(ticket.id)"
            
            // 2. Dates
            // Use formattedDate for the start date
            dateStartedLabel.text = "Date Started: \(ticket.formattedDate)"
            
            // Check if a completion date exists in the model
            if let completionDate = ticket.dateCompleted {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                completedAtLabel.text = "Completed At: \(formatter.string(from: completionDate))"
            } else {
                completedAtLabel.text = "Completed At: N/A"
            }

            // 3. Metadata
            priorityLevelLabel.text = "Priority Level: \(ticket.priority.rawValue.capitalized)"
            priorityLevelLabel.textColor = ticket.priority.color
            
            // Placeholder for feedback which may be implemented later
            userFeedbackLabel.text = "User Feedback: No feedback provided yet."
    }
}
