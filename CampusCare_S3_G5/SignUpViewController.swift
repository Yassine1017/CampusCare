//
//  SignUpViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 18/12/2025.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmailPhone: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Email / Phone field setup
        txtEmailPhone.keyboardType = .emailAddress
        txtEmailPhone.autocapitalizationType = .none
        txtEmailPhone.autocorrectionType = .no

        // Password fields setup
        txtPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true

        // Dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func signUpTapped(_ sender: UIButton) {

        let fullName = txtFullName.text ?? ""
        let emailPhone = txtEmailPhone.text ?? ""
        let username = txtUsername.text ?? ""
        let password = txtPassword.text ?? ""
        let confirmPassword = txtConfirmPassword.text ?? ""

        // 1️⃣ Check empty fields
        if fullName.isEmpty ||
           emailPhone.isEmpty ||
           username.isEmpty ||
           password.isEmpty ||
           confirmPassword.isEmpty {

            showAlert(title: "Missing Information",
                      message: "Please fill in all fields.")
            return
        }

        // 2️⃣ Validate email format
        if !isValidEmail(emailPhone) {
            showAlert(title: "Invalid Email",
                      message: "Please enter a valid email address.")
            return
        }

        // 3️⃣ Validate password length
        if password.count < 6 {
            showAlert(title: "Weak Password",
                      message: "Password must be at least 6 characters.")
            return
        }

        // 4️⃣ Validate password match
        if password != confirmPassword {
            showAlert(title: "Password Error",
                      message: "Passwords do not match.")
            return
        }

        // 5️⃣ Save data (temporary using UserDefaults)
        UserDefaults.standard.set(fullName, forKey: "fullName")
        UserDefaults.standard.set(emailPhone, forKey: "emailPhone")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")

        // 6️⃣ Success alert
        let alert = UIAlertController(
            title: "Success",
            message: "Account created successfully.",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Go back to Login page
            self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        // Go back to Login page
        navigationController?.popViewController(animated: true)
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

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
