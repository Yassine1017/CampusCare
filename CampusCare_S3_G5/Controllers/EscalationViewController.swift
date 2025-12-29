//
//  EscalationViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-02 on 25/12/2025.
//

import UIKit

class EscalationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var reasoningTextView: UITextView!
    @IBOutlet weak var maintenanceIDLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    
    // MARK: - Properties
    var ticketID: String?
    let characterLimit = 180

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reasoningTextView.delegate = self
    }
    
    private func setupUI() {
        // Display the ID passed from the previous screen
        if let id = ticketID {
            maintenanceIDLabel.text = "#\(id)"
        }
        
        // Style the TextView so users see where to type
        reasoningTextView.layer.borderWidth = 0.5
        reasoningTextView.layer.borderColor = UIColor.lightGray.cgColor
        reasoningTextView.layer.cornerRadius = 8
        
        // Optional: Add a "Done" button to keyboard to dismiss it
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        reasoningTextView.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func proceedButtonTapped(_ sender: UIButton) {
        let userReasoning = reasoningTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if userReasoning.isEmpty {
            // Requirement: Error if empty
            showAlert(title: "Reason Required", message: "Please specify why you are escalating this request before proceeding.")
        } else {
            // Requirement: Ask for confirmation if text exists
            showConfirmationAlert()
        }
    }
    
    private func showConfirmationAlert() {
        let alert = UIAlertController(
            title: "Confirm Escalation",
            message: "Are you sure you want to submit this escalation request for Ticket #\(ticketID ?? "")?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            print("Escalation Submitted: \(self.reasoningTextView.text!)")
            // Future logic: Send to Firebase here
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension EscalationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Calculate the new length if the change is allowed
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // 2. Enforce the 180 character limit
        let isWithinLimit = updatedText.count <= characterLimit
        
        return isWithinLimit
    }
}
