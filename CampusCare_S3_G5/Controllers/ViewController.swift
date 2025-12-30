import UIKit

class ViewController: UIViewController {

    @IBAction func didTapFeedbackButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyFeedBack", bundle: nil)
        
        if let feedbackVC = storyboard.instantiateViewController(withIdentifier: "FeedbackRatingVC") as? FeedBackRating {
            
            // CRITICAL: Connect the delegate
            // This ensures the data flows back to your history list
            feedbackVC.delegate = self.findHistoryViewController()
            
            feedbackVC.modalPresentationStyle = .fullScreen
            self.present(feedbackVC, animated: true, completion: nil)
        }
    }
    
    // Helper to find your history controller in the app
    private func findHistoryViewController() -> FeedbackHistoryViewController? {
        // Implementation depends on if your history page is in a TabBar or NavController
        return self.presentingViewController as? FeedbackHistoryViewController
    }
}
