//
//  DetailedRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-08 on 25/12/2025.
//

import UIKit

class DetailedRequestViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var maintenanceIDLabel: UILabel!
    @IBOutlet weak var dateStartedLabel: UILabel!
    @IBOutlet weak var priorityLevelLabel: UILabel!
    @IBOutlet weak var requestDueWarningLabel: UILabel!
    @IBOutlet weak var statusPicker: UIPickerView!
    
    // MARK: - Properties
        var selectedTicket: Ticket?
        let statusOptions = TicketStatus.allCases // Ensure TicketStatus is CaseIterable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Data binding should happen here or in viewDidLoad
            // to ensure outlets are connected
            configureWithTicket()
            print("Ticket Description is: \(selectedTicket?.description ?? "N/A")")
        }
    

    private func setupUI() {
            statusPicker.delegate = self
            statusPicker.dataSource = self
            
            // Make text view read-only
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
            priorityLevelLabel.text = "Priority Level: \(ticket.priority.rawValue)"
            priorityLevelLabel.textColor = ticket.priority.color
            
            // Handle Due Date Warning
            if Date() > ticket.dueDate && ticket.status != .completed {
                requestDueWarningLabel.text = "⚠️ REQUEST OVERDUE"
                requestDueWarningLabel.textColor = .systemRed
            } else {
                requestDueWarningLabel.text = ""
            }
            
            // Set picker to current status
            if let index = statusOptions.firstIndex(of: ticket.status) {
                statusPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        private func showCompletionAlert(forRow row: Int) {
            let alert = UIAlertController(
                title: "Confirm Completion",
                message: "Are you sure you want to mark this ticket as Completed? This action usually closes the request.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                // Revert picker if they cancel
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
            print("Ticket \(selectedTicket?.id ?? "") updated to \(newStatus.rawValue)")
            // Here you would typically call a Firebase update function
        }
    
    @IBAction func escalateRequestTapped(_ sender: UIButton) {
        // Trigger the transition
        performSegue(withIdentifier: "showEscalation", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEscalation",
           let destinationVC = segue.destination as? EscalationViewController {
            // Pass the ID of the current selected ticket
            destinationVC.ticketID = selectedTicket?.id
        }
    }
    }

    // MARK: - Picker View Methods
    extension DetailedRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return statusOptions.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return statusOptions[row].rawValue
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
