//
//  SignUpViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 18/12/2025.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFields()
        configurePasswordFields()
        setupKeyboardDismiss()
        title = "Sign Up"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI Configuration

    private func configureTextFields() {
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no

        txtUsername.autocapitalizationType = .none
        txtUsername.autocorrectionType = .no
    }

    private func configurePasswordFields() {
        txtPassword.isSecureTextEntry = true
        txtPassword.textContentType = .newPassword
        txtPassword.passwordRules = UITextInputPasswordRules(
            descriptor: "required: upper; required: lower; required: digit; minlength: 6;"
        )
        txtPassword.autocapitalizationType = .none
        txtPassword.autocorrectionType = .no

        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.textContentType = .newPassword
        txtConfirmPassword.autocapitalizationType = .none
        txtConfirmPassword.autocorrectionType = .no
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func signUpTapped(_ sender: UIButton) {

        let fullName = txtFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let username = txtUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = txtPassword.text ?? ""
        let confirmPassword = txtConfirmPassword.text ?? ""

        // Check for empty fields
        guard !fullName.isEmpty,
              !email.isEmpty,
              !username.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert(title: "Missing Information",
                      message: "Please fill in all fields.")
            return
        }

        // Validate email format
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email",
                      message: "Please enter a valid email address.")
            return
        }

        // Validate password length
        guard password.count >= 6 else {
            showAlert(title: "Weak Password",
                      message: "Password must be at least 6 characters.")
            return
        }

        // Validate password match
        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch",
                      message: "Passwords do not match.")
            return
        }

        // Create user with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(title: "Error",
                                message: error.localizedDescription)
                return
            }

            guard let user = result?.user else { return }

            // Update display name
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    self?.showAlert(title: "Profile Error",
                                    message: error.localizedDescription)
                    return
                }

                // Send email verification
                user.sendEmailVerification { error in
                    if let error = error {
                        self?.showAlert(title: "Verification Error",
                                        message: error.localizedDescription)
                        return
                    }

                    // Save non-sensitive user data locally (optional)
                    UserDefaults.standard.set(fullName, forKey: "fullName")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(username, forKey: "username")

                    // Success alert
                    let alert = UIAlertController(
                        title: "Verify Your Email",
                        message: "A verification email has been sent. Please check your inbox and verify your email before logging in.",
                        preferredStyle: .alert
                    )

                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })

                    self?.present(alert, animated: true)
                }
            }
        }
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

