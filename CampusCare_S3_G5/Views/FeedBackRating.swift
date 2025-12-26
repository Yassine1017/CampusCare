import UIKit

// The protocol acts as the "river" to carry data back to the list
protocol FeedbackDelegate: AnyObject {
    func didSubmitNewFeedback(_ activity: ActivityHistory)
}

class FeedBackRating: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    weak var delegate: FeedbackDelegate?
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
            let imageName = button.tag <= currentRating ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        let userComment = reviewTextView.text ?? ""
        
        // 1. Create a Review using your existing model
        let newReview = Review(rating: currentRating, comment: userComment)
        
        // 2. Save it to the Manager (This is what makes it "show up" later)
        FeedbackManager.shared.allReviews.insert(newReview, at: 0)
        
        // 3. Show success message
        let alert = UIAlertController(title: "Success", message: "Feedback saved!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
