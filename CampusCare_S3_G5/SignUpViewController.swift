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
    @IBOutlet weak var txtEmailPhone: UITextField!
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar on Sign Up screen
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show navigation bar when leaving screen
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI Configuration

    /// Configures non-password text fields
    private func configureTextFields() {
        txtEmailPhone.keyboardType = .emailAddress
        txtEmailPhone.autocapitalizationType = .none
        txtEmailPhone.autocorrectionType = .no

        txtUsername.autocapitalizationType = .none
        txtUsername.autocorrectionType = .no
    }

    /// Configures password fields to work correctly with iOS AutoFill
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

    /// Dismisses keyboard when tapping outside text fields
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
        let email = txtEmailPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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

        // Firebase Authentication - Create user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(title: "Error",
                                message: error.localizedDescription)
                return
            }

            guard let user = result?.user else { return }

            // Update Firebase display name
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    self?.showAlert(title: "Profile Error",
                                    message: error.localizedDescription)
                    return
                }

                // Save non-sensitive user data locally
                UserDefaults.standard.set(fullName, forKey: "fullName")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(username, forKey: "username")

                // Success alert
                let alert = UIAlertController(
                    title: "Success",
                    message: "Account created successfully.",
                    preferredStyle: .alert
                )

                let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }

                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    // MARK: - Helpers

    /// Displays a simple alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    /// Validates email format
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
