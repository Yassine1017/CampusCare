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
    @IBAction func feedbackStatsTapped(_ sender: UIButton) {
        // 1. Load the storyboard named "FeedbackStats"
        let storyboard = UIStoryboard(name: "FeedbackStats", bundle: nil)
        
        // 2. Instantiate the first screen (The Entry Point)
        if let statsVC = storyboard.instantiateInitialViewController() {
            
            // 3. Set presentation style (Full Screen looks best for dashboards)
            statsVC.modalPresentationStyle = .fullScreen
            
            // 4. Show the screen
            self.present(statsVC, animated: true, completion: nil)
        } else {
            print("Error: Could not find the initial view controller in FeedbackStats.storyboard")
        }
    }
    @IBAction func technicianPerformanceTapped(_ sender: UIButton) {
        // 1. Point to the specific storyboard file name
        let storyboard = UIStoryboard(name: "TechnincanPerformance", bundle: nil)
        
        // 2. Instantiate the initial view controller (the one with the arrow)
        if let performanceVC = storyboard.instantiateInitialViewController() {
            
            // 3. Set the presentation style
            performanceVC.modalPresentationStyle = .fullScreen
            
            // 4. Present the screen
            self.present(performanceVC, animated: true, completion: nil)
        } else {
            print("Error: Check if 'Is Initial View Controller' is checked in TechnincanPerformance.storyboard")
        }
    }
}
