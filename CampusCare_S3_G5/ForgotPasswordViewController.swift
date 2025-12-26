//
//  ForgotPasswordViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 18/12/2025.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var btSubmit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure email text field
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no
        
        // Set navigation title
        navigationItem.title = "Forgot Password"
        
        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure navigation bar is visible
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Keep navigation bar visible when leaving
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        view.endEditing(true)
        
        let email = txtEmail.text ?? ""
        
        // 1️⃣ Check if email field is empty
        if email.isEmpty {
            showAlert(title: "Missing Information",
                      message: "Please enter your email address.")
            return
        }

        // 2️⃣ Validate email format
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email",
                      message: "Please enter a valid email address.")
            return
        }

        // 3️⃣ Send password reset email via Firebase
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error",
                                message: error.localizedDescription)
                return
            }

            // 4️⃣ Show success alert and return to Login screen
            let alert = UIAlertController(
                title: "Password Reset",
                message: "A password reset link has been sent to your email.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // Go back to LoginViewController
                self?.navigationController?.popViewController(animated: true)
            })
            
            self?.present(alert, animated: true)
        }
    }
    
    // MARK: - Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // Email validation helper
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
