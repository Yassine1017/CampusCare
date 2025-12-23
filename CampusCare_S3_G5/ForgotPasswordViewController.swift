//
//  ForgotPasswordViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 18/12/2025.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailOrPhoneTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for the email/phone number field (email validation is optional)
        emailOrPhoneTextField.keyboardType = .emailAddress
        emailOrPhoneTextField.autocapitalizationType = .none
        emailOrPhoneTextField.autocorrectionType = .no
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        // Get the entered email/phone number
        let emailOrPhone = emailOrPhoneTextField.text ?? ""
        
        // 1️⃣ Check if the field is empty
        if emailOrPhone.isEmpty {
            showAlert(title: "Missing Information", message: "Please enter your email or phone number.")
            return
        }

        // 2️⃣ Validate email format
        if !isValidEmail(emailOrPhone) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        // 3️⃣ Firebase Password Reset
        Auth.auth().sendPasswordReset(withEmail: emailOrPhone) { [weak self] (error) in
            if let error = error {
                self?.showAlert(
                    title: "Error",
                    message: error.localizedDescription
                )
                return
            }

            // 4️⃣ Success alert
            self?.showAlert(
                title: "Password Reset",
                message: "A password reset link has been sent to your email."
            )
        }
    }
    
    // MARK: - Helpers
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // Email Validation Helper
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
