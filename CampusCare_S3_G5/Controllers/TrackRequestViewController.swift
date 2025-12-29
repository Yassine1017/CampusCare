//
//  TrackRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by ESKY on 20/12/2025.
//

import UIKit
import FirebaseFirestore

class TrackRequestViewController: UIViewController {

    // MARK: - Passed from previous screen
    var request: Ticket!

    // MARK: - Outlets
    @IBOutlet weak var requestIdTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var assignmentDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addFeedbackButton: UIButton!

    // MARK: - Firebase
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Safety guard
        guard request != nil else {
            assertionFailure("TrackRequestViewController.request was nil")
            navigationController?.popViewController(animated: true)
            return
        }

        // Initial UI state
        addFeedbackButton.isHidden = true
        descriptionTextField.isUserInteractionEnabled = false

        startListening()
    }

    deinit {
        listener?.remove()
    }

    // MARK: - Firestore Live Listener
    private func startListening() {

        listener = db
            .collection("tickets")
            .document(request.id)
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }

                if let error = error {
                    print("Firestore listener error:", error)
                    return
                }

                guard
                    let snapshot = snapshot,
                    snapshot.exists,
                    let ticket = try? snapshot.data(as: Ticket.self)
                else {
                    return
                }

                self.updateUI(with: ticket)
            }
    }

    // MARK: - UI Update
    private func updateUI(with ticket: Ticket) {

        requestIdTextField.text = "#\(ticket.id)"
        statusTextField.text = ticket.status.rawValue
        categoryTextField.text = ticket.category
        descriptionTextField.text = ticket.description

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        assignmentDateTextField.text = formatter.string(from: ticket.dateCommenced)

        // ⭐ Show Add Feedback only when completed
        addFeedbackButton.isHidden = (ticket.status != .completed)
    }

    // MARK: - Actions
    @IBAction func addFeedbackTapped(_ sender: UIButton) {
        print("Add Feedback tapped for ticket \(request.id)")
    }
}
