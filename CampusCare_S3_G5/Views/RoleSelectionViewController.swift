import UIKit

class RoleSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // This hides the back button so users can't go back to the rating screen
        self.navigationItem.hidesBackButton = true
    }

    // This function will run when you click the "User" button
    @IBAction func userButtonTapped(_ sender: UIButton) {
        
        // 1. Find the Storyboard named "MyFeedBack"
        let storyboard = UIStoryboard(name: "MyFeedBack", bundle: nil)
        
        // 2. Grab the first screen (the Initial View Controller) from that storyboard
        if let feedbackListVC = storyboard.instantiateInitialViewController() {
            
            // 3. Set it to full screen
            feedbackListVC.modalPresentationStyle = .fullScreen
            
            // 4. Show it
            self.present(feedbackListVC, animated: true, completion: nil)
        }
    }
}
