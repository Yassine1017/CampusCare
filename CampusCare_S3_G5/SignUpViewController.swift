//
//  SignUpViewController.swift
//  CampusCare_S3_G5
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
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

    // MARK: - TextField Configuration
    private func configureTextFields() {

        // Email
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no

        // Username
        txtUsername.autocapitalizationType = .none
        txtUsername.autocorrectionType = .no
    }

    // MARK: - Password Configuration
    /// Completely disables iOS Strong Password & Autofill
    private func configurePasswordFields() {

        txtPassword.isSecureTextEntry = true
        txtPassword.textContentType = nil
        txtPassword.autocapitalizationType = .none
        txtPassword.autocorrectionType = .no

        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.textContentType = nil
        txtConfirmPassword.autocapitalizationType = .none
        txtConfirmPassword.autocorrectionType = .no
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tapGesture)
    }

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

        // Empty field validation
        guard !fullName.isEmpty,
              !email.isEmpty,
              !username.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in all fields.")
            return
        }

        // Email validation
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        // Password match validation
        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return
        }

        // Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in

            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            guard let self = self, let user = result?.user else { return }

            // Set display name
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges()

            // Save user to Firestore
            Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .setData([
                    "fullName": fullName,
                    "username": username,
                    "email": email,
                    "role": "student",
                    "createdAt": Timestamp()
                ])

            // Success alert
            let alert = UIAlertController(
                title: "Success",
                message: "Account created successfully. You can now log in.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })

            self.present(alert, animated: true)
        }
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

