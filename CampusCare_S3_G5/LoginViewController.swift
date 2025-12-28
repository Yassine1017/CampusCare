//
//  LoginViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 15/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var email: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure email field
        email.keyboardType = .emailAddress
        email.autocapitalizationType = .none
        email.autocorrectionType = .no

        // Secure password field
        passwordTextField.isSecureTextEntry = true

        // Dismiss keyboard when tapping outside
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)

        // Validate email
        guard let enteredEmail = email.text, !enteredEmail.isEmpty else {
            showAlert(title: "Missing Email",
                      message: "Please enter your email address.")
            return
        }

        // Validate password
        guard let enteredPassword = passwordTextField.text, !enteredPassword.isEmpty else {
            showAlert(title: "Missing Password",
                      message: "Please enter your password.")
            return
        }

        // 🔐 Firebase Sign In
        Auth.auth().signIn(withEmail: enteredEmail,
                           password: enteredPassword) { [weak self] result, error in
            if let error = error {
                self?.showAlert(title: "Login Failed",
                                message: error.localizedDescription)
                return
            }

            guard let self = self,
                  let uid = Auth.auth().currentUser?.uid else { return }

            // 📦 Fetch user data from Firestore
            let db = Firestore.firestore()
            db.collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    self.showAlert(title: "Error",
                                   message: error.localizedDescription)
                    return
                }

                guard let data = snapshot?.data() else {
                    self.showAlert(title: "Error",
                                   message: "User data not found.")
                    return
                }

                let username = data["username"] as? String ?? ""
                let role = data["role"] as? String ?? "student"

                print("Logged in as \(username) | role: \(role)")

                // ✅ Login success
                self.showAlert(
                    title: "Success",
                    message: "Welcome \(username)"
                )

                // 🔀 Navigate based on role (optional)
                // if role == "admin" {
                //     self.performSegue(withIdentifier: "goToAdminHome", sender: nil)
                // } else {
                //     self.performSegue(withIdentifier: "goToHomePage", sender: nil)
                // }
            }
        }
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Navigate to Sign Up screen
        // self.performSegue(withIdentifier: "goToSignUp", sender: nil)
    }

    // MARK: - Alert Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
