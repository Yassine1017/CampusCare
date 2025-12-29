//
//  DetailedEscalatedViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-18 on 28/12/2025.
//


import UIKit

class DetailedEscalatedViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var maintenanceIDLabel: UILabel!
    @IBOutlet weak var dateStartedLabel: UILabel!
    @IBOutlet weak var escalatedAtLabel: UILabel!
    @IBOutlet weak var escalatedToLabel: UILabel!
    @IBOutlet weak var statedReasonLabel: UILabel!

    // MARK: - Properties
    var selectedTicket: Ticket?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Escalated Requests"
        configureUI()
    }

    private func configureUI() {
        guard let ticket = selectedTicket else { return }

        // 1. Description
        descriptionTextView.text = ticket.description

        // 2. Identification and Timeline
        maintenanceIDLabel.text = "Maintenance ID: #\(ticket.id)"
        dateStartedLabel.text = "Date Started: \(ticket.formattedDate)"
        
        // Using the ticket's start date as a placeholder for Escalated At
        escalatedAtLabel.text = "Escalated At: \(ticket.formattedDate)"

        // 3. Escalation Details
        // escalatedTo is currently a placeholder; you can add a field to your Ticket struct later
        escalatedToLabel.text = "Escalated To: Senior Supervisor"
        
        // Stated Reason uses the escalationReason property from the Ticket model
        statedReasonLabel.text = "Stated Reason: \(ticket.escalationReason ?? "No reason provided.")"
    }
}
