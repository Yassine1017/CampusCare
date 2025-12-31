import UIKit
import FirebaseCore
import FirebaseFirestore

// The protocol acts as the "river" to carry data back to the list
protocol FeedbackDelegate: AnyObject {
    func didSubmitNewFeedback(_ activity: ActivityHistory)
}

class FeedBackRating: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    weak var delegate: FeedbackDelegate?
    var currentRating: Int = 0
    var ticketID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.borderWidth = 0.5
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func starTapped(_ sender: UIButton) {
        currentRating = sender.tag
        for button in starButtons {
            let imageName = button.tag <= currentRating ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    let db = Firestore.firestore()

    @IBAction func submitPressed(_ sender: UIButton) {
            guard let tID = ticketID else { return }
            let userComment = reviewTextView.text ?? ""
                
            let feedbackData: [String: Any] = [
                "rating": currentRating,
                "comment": userComment,
                "date": Timestamp(date: Date()),
                "ticketId": tID // Link feedback to this specific ticket
            ]
                
            // 1. Save feedback
            db.collection("feedbacks").addDocument(data: feedbackData) { [weak self] error in
                if error == nil {
                    // 2. Mark the ticket as having feedback so it can't be done again
                    self?.db.collection("tickets").document(tID).updateData([
                        "hasFeedback": true
                    ]) { _ in
                        self?.showAlert(title: "Success", message: "Feedback sent to database!")
                    }
                }
            }
    }
        
    // Helper function to show alerts easily
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if title == "Success" {
                // --- NAVIGATION START ---
                // This manually loads the RepairRequestSystem storyboard and shows it
                let storyboard = UIStoryboard(name: "RepairRequestSystem", bundle: nil)
                if let vc = storyboard.instantiateInitialViewController() {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                // --- NAVIGATION END ---
            }
        })
        present(alert, animated: true)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RepairRequestSystem", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RepairRequestSystem")
        navigationController?.pushViewController(vc, animated: true)
    }
}
