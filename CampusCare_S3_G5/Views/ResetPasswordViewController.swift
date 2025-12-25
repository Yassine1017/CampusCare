//
//  ResetPasswordViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 23/12/2025.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var email: String?  // Variable to hold the user's email, passed from the previous screen
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // You can display the user's email here for reference, if needed
        // For example, to show the email in a label: emailLabel.text = email
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        if let nav = navigationController {
                nav.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        navigationItem.title = "Reset Password"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar again when leaving this screen
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let newPasswordText = newPassword.text, !newPasswordText.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter a new password.")
            return
        }
        
        guard let confirmPasswordText = confirmPassword.text, !confirmPasswordText.isEmpty else {
            showAlert(title: "Missing Information", message: "Please confirm your new password.")
            return
        }
        
        // 1️⃣ Check if the new password and confirmation match
        if newPasswordText != confirmPasswordText {
            showAlert(title: "Password Error", message: "Passwords do not match.")
            return
        }
        
        // 2️⃣ Check password length (for example, at least 6 characters)
        if newPasswordText.count < 6 {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return
        }
        
        // 3️⃣ Proceed with resetting the password via Firebase
        guard let email = email else {
            showAlert(title: "Error", message: "No email provided.")
            return
        }
        
        // 4️⃣ Reset the password via Firebase
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            // 5️⃣ Success alert
            self?.showAlert(title: "Success", message: "Password reset link sent to \(email). Please check your inbox.")
            // Optionally navigate back to the login screen or show additional info
        }
    }
    
    // MARK: - Helper Functions
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

