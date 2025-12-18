//
//  signInPageViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 15/12/2025.
//

import UIKit

class signInPageViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailOrPhoneTextField: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Email / Phone field
        emailOrPhoneTextField.keyboardType = .emailAddress
        emailOrPhoneTextField.autocapitalizationType = .none
        emailOrPhoneTextField.autocorrectionType = .no

        // Hide password text
        passwordTextField.isSecureTextEntry = true

        // Close keyboard when tapping anywhere on screen
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {

        view.endEditing(true)

        let enteredEmail = emailOrPhoneTextField.text ?? ""
        let enteredPassword = passwordTextField.text ?? ""

        // 1️⃣ Check empty fields
        if enteredEmail.isEmpty || enteredPassword.isEmpty {
            showAlert(
                title: "Missing Information",
                message: "Please enter your email/phone and password."
            )
            return
        }

        // 2️⃣ Get saved Sign Up data
        let savedEmail = UserDefaults.standard.string(forKey: "emailPhone")
        let savedPassword = UserDefaults.standard.string(forKey: "password")

        // 3️⃣ Check if user has signed up
        if savedEmail == nil || savedPassword == nil {
            showAlert(
                title: "No Account Found",
                message: "Please sign up first."
            )
            return
        }

        // 4️⃣ Validate login credentials
        if enteredEmail == savedEmail && enteredPassword == savedPassword {

            showAlert(
                title: "Success",
                message: "Login successful. Welcome."
            )

        } else {

            showAlert(
                title: "Login Failed",
                message: "Incorrect email or password."
            )
        }
    }

    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "goToForgotPassword", sender: nil)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
       
    }

    // MARK: - Alert Helper
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
