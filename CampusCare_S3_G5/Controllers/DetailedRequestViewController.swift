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
        var statusOptions: [TicketStatus] {
            return TicketStatus.allCases.filter { $0 != .new }
        }
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
                    message: "Are you sure you want to mark this request as completed? This will notify the user.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Complete", style: .default) { _ in
                    // Call the update function with the completed status
                    self.updateTicketStatus(to: .completed)
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    // Revert the picker if they cancel
                    if let currentStatus = self.selectedTicket?.status,
                       let index = self.statusOptions.firstIndex(of: currentStatus) {
                        self.statusPicker.selectRow(index, inComponent: 0, animated: true)
                    }
                })
                
                present(alert, animated: true)
        }
            
    private func updateTicketStatus(to status: TicketStatus) {
        guard let ticketID = selectedTicket?.id else { return }
        
        let db = Firestore.firestore()
        let ticketRef = db.collection("tickets").document(ticketID)
        
        // Prepare the update data
        var updateData: [String: Any] = ["status": status.rawValue]
        
        // If completing, we also set a completion timestamp
        if status == .completed {
            updateData["dateCompleted"] = Timestamp(date: Date())
        }
        
        ticketRef.updateData(updateData) { [weak self] error in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
                self?.showAlert("Update Failed", error.localizedDescription)
            } else {
                print("Status successfully updated to \(status.rawValue)")
                // Update local model to match UI
                self?.selectedTicket?.status = status
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
                    // Trigger the confirmation alert
                    showCompletionAlert(forRow: row)
                } else {
                    // Standard update for other statuses
                    updateTicketStatus(to: selectedStatus)
                }
        }
        // MARK: - Helpers
        private func showAlert(_ title: String, _ message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        
}
