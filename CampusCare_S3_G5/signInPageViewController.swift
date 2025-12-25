//
//  signInPageViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 15/12/2025.
//

import UIKit
import FirebaseAuth

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
        title = "Login"
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

        // 2️⃣ Firebase Sign-In
        Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { [weak self] (result, error) in
            if let error = error {
                self?.showAlert(
                    title: "Login Failed",
                    message: error.localizedDescription
                )
                return
            }

            // 3️⃣ Login Success
            self?.showAlert(
                title: "Success",
                message: "Login successful. Welcome."
            )
            
            // Proceed to next screen or user flow
            // self?.performSegue(withIdentifier: "goToHomePage", sender: nil)
        }
    }

    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        let email = emailOrPhoneTextField.text ?? ""
        if email.isEmpty {
            showAlert(
                title: "Missing Information",
                message: "Please enter your email to reset the password."
            )
            return
        }
        
        // Firebase Password Reset
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(
                    title: "Error",
                    message: error.localizedDescription
                )
                return
            }

            self?.showAlert(
                title: "Password Reset",
                message: "A password reset link has been sent to your email."
            )
        }
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Transition to registration page
        // performSegue(withIdentifier: "goToSignUp", sender: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if let nav = navigationController {
                nav.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
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
