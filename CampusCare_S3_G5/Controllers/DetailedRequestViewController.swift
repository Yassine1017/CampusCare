//
//  DetailedRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-08 on 25/12/2025.
//

import UIKit
import FirebaseFirestore

class DetailedRequestViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var maintenanceIDLabel: UILabel!
    @IBOutlet weak var dateStartedLabel: UILabel!
    @IBOutlet weak var priorityLevelLabel: UILabel!
    @IBOutlet weak var requestDueWarningLabel: UILabel!
    @IBOutlet weak var statusPicker: UIPickerView!
    
    // MARK: - Properties
        var selectedTicket: Ticket?
        let statusOptions = TicketStatus.allCases
        
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            configureWithTicket()
        }

        // MARK: - UI Configuration
        private func setupUI() {
            self.title = "Request Details"
            
            statusPicker.delegate = self
            statusPicker.dataSource = self
            
            // Make text view read-only and styled
            descriptionTextView.isEditable = false
            descriptionTextView.layer.borderWidth = 0.5
            descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
            descriptionTextView.layer.cornerRadius = 8
        }
            
        private func configureWithTicket() {
            guard let ticket = selectedTicket else { return }
            
            descriptionTextView.text = ticket.description
            maintenanceIDLabel.text = "Maintenance ID: #\(ticket.id)"
            dateStartedLabel.text = "Date Started: \(ticket.formattedDate)"
            priorityLevelLabel.text = "Priority Level: \(ticket.priority.rawValue.capitalized)"
            priorityLevelLabel.textColor = ticket.priority.color
            
            // Handle Overdue Logic
            // Logic: Current date is past due date AND ticket is not yet finished
            if Date() > ticket.dueDate && ticket.status != .completed {
                requestDueWarningLabel.text = "⚠️ REQUEST OVERDUE"
                requestDueWarningLabel.textColor = .systemRed
            } else {
                requestDueWarningLabel.text = ""
            }
            
            // Synchronize picker with the ticket's current status
            if let index = statusOptions.firstIndex(of: ticket.status) {
                statusPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
            
        // MARK: - Status Update Logic
        private func showCompletionAlert(forRow row: Int) {
            let alert = UIAlertController(
                title: "Confirm Completion",
                message: "Are you sure you want to mark this ticket as Completed? This action will move it to the historical records.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                // Revert picker to original status if cancelled
                if let index = self.statusOptions.firstIndex(of: self.selectedTicket?.status ?? .new) {
                    self.statusPicker.selectRow(index, inComponent: 0, animated: true)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.updateTicketStatus(to: self.statusOptions[row])
            }))
            
            present(alert, animated: true)
        }
            
    private func updateTicketStatus(to newStatus: TicketStatus) {
        guard let ticket = selectedTicket else { return }
        
        let db = Firestore.firestore()
        let ticketRef = db.collection("tickets").document(ticket.id)
        
        // Prepare the data to update
        var updateData: [String: Any] = ["status": newStatus.rawValue]
        
        // If completed, we also record the completion timestamp
        if newStatus == .completed {
            updateData["dateCompleted"] = Timestamp(date: Date())
        }
        
        ticketRef.updateData(updateData) { [weak self] error in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
                // Optionally show an alert to the user here
            } else {
                print("Successfully updated ticket \(ticket.id) to \(newStatus.rawValue)")
                
                // If the status is completed, go back to the dashboard
                if newStatus == .completed {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
        
        // MARK: - Actions
        @IBAction func escalateRequestTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "showEscalation", sender: self)
        }

        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showEscalation",
               let destinationVC = segue.destination as? EscalationViewController {
                // Pass the ID of the current selected ticket to link the escalation reason
                destinationVC.ticketID = selectedTicket?.id
            }
        }
    }

    // MARK: - Picker View Methods
    extension DetailedRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return statusOptions.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return statusOptions[row].rawValue.capitalized
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedStatus = statusOptions[row]
            
            if selectedStatus == .completed {
                showCompletionAlert(forRow: row)
            } else {
                updateTicketStatus(to: selectedStatus)
            }
        }
}
