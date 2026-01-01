import UIKit
import FirebaseCore
import FirebaseFirestore

protocol FeedbackDelegate: AnyObject {
    func didSubmitNewFeedback()
}

class FeedBackRating: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    weak var delegate: FeedbackDelegate?
    var currentRating: Int = 0
    var ticketID: String?
    
    // This variable is now correctly filled by TrackRequestViewController
    var technicianID: String?
    
    let db = Firestore.firestore()

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

    @IBAction func submitPressed(_ sender: UIButton) {
        guard let tID = ticketID else { return }
        
        // This guard will now pass because we are sending technicianID from the previous screen
        guard let techUID = technicianID else {
            print("Error: No technician ID found for this ticket")
            return
        }
        
        let userComment = reviewTextView.text ?? ""
            
        let feedbackData: [String: Any] = [
            "rating": currentRating,
            "comment": userComment,
            "date": Timestamp(date: Date()),
            "ticketId": tID,
            "technicianId": techUID // Saves the correct UID for the Admin Performance page
        ]
            
        db.collection("feedbacks").addDocument(data: feedbackData) { [weak self] error in
            if error == nil {
                self?.db.collection("tickets").document(tID).updateData(["hasFeedback": true]) { _ in
                    self?.delegate?.didSubmitNewFeedback()
                    self?.showAlert(title: "Success", message: "Thank you for your Feedback!")
                }
            }
        }
    }
        
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if title == "Success" {
                let storyboard = UIStoryboard(name: "RepairRequestSystem", bundle: nil)
                if let vc = storyboard.instantiateInitialViewController() {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
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
