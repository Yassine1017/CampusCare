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
    @IBOutlet weak var technicianNameTextField: UITextField!
    @IBOutlet weak var technicianIdTextField: UITextField!
    
    // MARK: - Firebase
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard request != nil else {
            assertionFailure("TrackRequestViewController.request was nil")
            navigationController?.popViewController(animated: true)
            return
        }
        
        addFeedbackButton.isHidden = true
        descriptionTextField.isUserInteractionEnabled = false
        technicianNameTextField.isUserInteractionEnabled = false
        technicianIdTextField.isUserInteractionEnabled = false
        
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
                self.loadTechnician(for: ticket)   // ✅ ADDED
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
        
        let isCompleted = (ticket.status == .completed)
        let alreadyHasFeedback = (ticket.hasFeedback ?? false)
        addFeedbackButton.isHidden = !(isCompleted && !alreadyHasFeedback)
    }
    
    // MARK: - Technician Loader (NEW, SMALL)
    private func loadTechnician(for ticket: Ticket) {
        
        guard let technicianId = ticket.assignedTo else {
            technicianNameTextField.text = "Not Assigned"
            technicianIdTextField.text = "—"
            return
        }
        
        db.collection("users")
            .document(technicianId)
            .getDocument { [weak self] snapshot, error in
                
                guard let self = self else { return }
                
                guard
                    let snapshot = snapshot,
                    let user = try? snapshot.data(as: User.self),
                    user.role == .technician
                else {
                    self.technicianNameTextField.text = "Unknown"
                    self.technicianIdTextField.text = technicianId
                    return
                }
                
                self.technicianNameTextField.text =
                "\(user.firstName) \(user.lastName)"
                self.technicianIdTextField.text = user.id
            }
    }
    
    // MARK: - Actions
    // MARK: - Actions
    @IBAction func addFeedbackTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "FeedBackRating", bundle: nil)
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "FeedBackRating"
        ) as? FeedBackRating else { return }
        
        // Pass the Ticket ID
        vc.ticketID = self.request.id
        
        // FIXED: Pass the technician's unique ID (assignedTo)
        // This ensures the feedback is linked to the right person forever.
        vc.technicianID = self.request.assignedTo
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
