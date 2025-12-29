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

        // 1. Text View Content
        descriptionTextView.text = ticket.description

        // 2. ID and Dates
        maintenanceIDLabel.text = "Maintenance ID: #\(ticket.id)"
        dateStartedLabel.text = "Date Started: \(ticket.formattedDate)"
        
        // Use a formatted string for completion date (placeholder if nil)
        completedAtLabel.text = "Completed At: \(ticket.formattedDate)" // For now reusing start date

        // 3. Priority and Feedback
        priorityLevelLabel.text = "Priority Level: \(ticket.priority.rawValue.capitalized)"
        userFeedbackLabel.text = "User Feedback: Pending..."
    }
}
