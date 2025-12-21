import UIKit

class FeedBackRating: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Final UI Polish
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.borderWidth = 0.5
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func starTapped(_ sender: UIButton) {
        let rating = sender.tag
        
        // Loop through all buttons in the collection
        for button in starButtons {
            if button.tag <= rating {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Success", message: "Feedback sent!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
