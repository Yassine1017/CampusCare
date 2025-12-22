import UIKit

class FeedBackRating: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    var currentRating: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.borderWidth = 0.5
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func starTapped(_ sender: UIButton) {
        currentRating = sender.tag
        for button in starButtons {
            button.setImage(UIImage(systemName: button.tag <= currentRating ? "star.fill" : "star"), for: .normal)
        }
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        let userComment = reviewTextView.text ?? ""
        
        // 1. Save data (This works and carries over!)
        let newReview = Review(rating: currentRating, comment: userComment)
        FeedbackManager.shared.allReviews.append(newReview)
        
        // 2. Alert
        let alert = UIAlertController(title: "Success", message: "Feedback saved!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // 3. Navigate back to Main
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let rootVC = storyboard.instantiateInitialViewController() {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = rootVC
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            } else {
                // Emergency fallback if you forgot the arrow in step 1
                self.dismiss(animated: true)
            }
        })
        present(alert, animated: true)
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
