import UIKit
import FirebaseAuth
import FirebaseFirestore

class AdminDashboradViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin Dashboard"
    }

    // MARK: - Button Actions (Storyboard Segues)

    @IBAction func viewRequestsTapped(_ sender: UIButton) {
        // Segue is connected from button in Storyboard
    }

    @IBAction func viewPerformanceTapped(_ sender: UIButton) {
        // Segue is connected from button in Storyboard
    }

    @IBAction func manageTechnicianTapped(_ sender: UIButton) {
        // Segue is connected from button in Storyboard
    }
    @IBAction func signOutTapped(_ sender: UIButton) {

        do {
            try Auth.auth().signOut()
        } catch {
            showAlert(title: "Error", message: "Failed to sign out.")
            return
        }

        // Go back to Login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let loginVC = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as? UIViewController else {
            return
        }

        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen

        // Replace root view controller (no back navigation)
        view.window?.rootViewController = nav
        view.window?.makeKeyAndVisible()
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
