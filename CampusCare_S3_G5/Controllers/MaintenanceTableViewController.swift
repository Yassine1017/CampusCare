//  MaintenanceTableViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 26/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MaintenanceTableViewController: UITableViewController, UITextViewDelegate {

    // MARK: - Outlets (Labels)
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    
    // MARK: - Outlets (Inputs)
    @IBOutlet weak var issueTextField: UITextField!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    private let detailsPlaceholder = "Additional details..."

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Maintenance Schedule"

        setupUI()
        setupTextViewPlaceholder()
        
        // Setup tap gesture to dismiss keyboard when tapping outside
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - Table View Overrides
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    

    // MARK: - UI Setup
    private func setupUI() {

        // TextView styling
        detailsTextView.layer.borderWidth = 0.5
        detailsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        detailsTextView.layer.cornerRadius = 8

        // Button styling
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("Submit", for: .normal)

        // Default values
        prioritySegment.selectedSegmentIndex = 0

        // Scheduling should be for now or future
        datePicker.minimumDate = Date()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - TextView Placeholder
    private func setupTextViewPlaceholder() {
        detailsTextView.delegate = self
        detailsTextView.text = detailsPlaceholder
        detailsTextView.textColor = .lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = detailsPlaceholder
            textView.textColor = .lightGray
        }
    }

    // MARK: - Actions
    @IBAction func submitTapped(_ sender: UIButton) {

        let issue = issueTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let location = locationTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let priority = prioritySegment.titleForSegment(
            at: prioritySegment.selectedSegmentIndex
        ) ?? "Low"

        let scheduledDate = datePicker.date

        let details =
            detailsTextView.textColor == .lightGray
            ? ""
            : detailsTextView.text ?? ""

        // Validation
        if issue.isEmpty || location.isEmpty {
            showAlert(
                title: "Missing Information",
                message: "Please fill in the Issue and Location fields."
            )
            return
        }

        saveScheduleToFirebase(
            issue: issue,
            priority: priority,
            location: location,
            scheduledDate: scheduledDate,
            details: details
        )
    }

    // MARK: - Firebase Firestore (Maintenance Schedule)
    private func saveScheduleToFirebase(
        issue: String,
        priority: String,
        location: String,
        scheduledDate: Date,
        details: String
    ) {

        let db = Firestore.firestore()

        let data: [String: Any] = [
            "issue": issue,
            "priority": priority,
            "location": location,
            "scheduledDate": Timestamp(date: scheduledDate),
            "details": details,
            "scheduleStatus": "Scheduled",
            "createdAt": Timestamp(),
            "scheduledBy": Auth.auth().currentUser?.uid ?? "anonymous"
        ]

        submitButton.isEnabled = false
        submitButton.alpha = 0.6

        db.collection("maintenance_schedules").addDocument(data: data) { error in

            self.submitButton.isEnabled = true
            self.submitButton.alpha = 1.0

            if let error = error {
                self.showAlert(
                    title: "Error",
                    message: error.localizedDescription
                )
            } else {
                self.showAlert(
                    title: "Success",
                    message: "Maintenance has been scheduled successfully."
                )
                self.clearForm()
            }
        }
    }

    // MARK: - Helpers
    private func clearForm() {
        issueTextField.text = ""
        locationTextField.text = ""
        prioritySegment.selectedSegmentIndex = 0
        datePicker.date = Date()

        detailsTextView.text = detailsPlaceholder
        detailsTextView.textColor = .lightGray
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
