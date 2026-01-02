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

        // 2. Identification & Timeline
        maintenanceIDLabel.text = "Maintenance ID: #\(ticket.id ?? "N/A")"
        dateStartedLabel.text = "Date Started: \(ticket.formattedDate)"

        // 3. Escalation Info
        escalatedAtLabel.text = "Escalated At: \(ticket.formattedEscalatedDate)"

        escalatedToLabel.text = "Escalated To: \(ticket.escalatedTo ?? "Not Assigned")"

        statedReasonLabel.text =
            "Stated Reason: \(ticket.escalationReason ?? "No reason provided.")"
    }
}
