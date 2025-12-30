//
//  SignUpViewController.swift
//  CampusCare_S3_G5
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"

        configureTextFields()
        configurePasswordFields()
        setupKeyboardDismiss()
    }

    // MARK: - TextField Configuration
    private func configureTextFields() {

        // First name
        txtFirstName.autocapitalizationType = .words
        txtFirstName.autocorrectionType = .no
        txtFirstName.textContentType = .givenName
        txtFirstName.smartInsertDeleteType = .no
        txtFirstName.smartDashesType = .no
        txtFirstName.smartQuotesType = .no

        // Last name
        txtLastName.autocapitalizationType = .words
        txtLastName.autocorrectionType = .no
        txtLastName.textContentType = .familyName
        txtLastName.smartInsertDeleteType = .no
        txtLastName.smartDashesType = .no
        txtLastName.smartQuotesType = .no

        // Email
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no
        txtEmail.textContentType = .emailAddress
        txtEmail.smartInsertDeleteType = .no
        txtEmail.smartDashesType = .no
        txtEmail.smartQuotesType = .no

        // Username
        txtUsername.autocapitalizationType = .none
        txtUsername.autocorrectionType = .no
        txtUsername.textContentType = .username
        txtUsername.smartInsertDeleteType = .no
        txtUsername.smartDashesType = .no
        txtUsername.smartQuotesType = .no
    }

    // MARK: - Password Configuration
    private func configurePasswordFields() {

        // Password
        txtPassword.isSecureTextEntry = true
        txtPassword.autocapitalizationType = .none
        txtPassword.autocorrectionType = .no
        txtPassword.textContentType = .oneTimeCode
        txtPassword.passwordRules = nil
        txtPassword.smartInsertDeleteType = .no
        txtPassword.smartDashesType = .no
        txtPassword.smartQuotesType = .no
        txtPassword.keyboardType = .asciiCapable

        // Confirm password
        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.autocapitalizationType = .none
        txtConfirmPassword.autocorrectionType = .no
        txtConfirmPassword.textContentType = .oneTimeCode
        txtConfirmPassword.passwordRules = nil
        txtConfirmPassword.smartInsertDeleteType = .no
        txtConfirmPassword.smartDashesType = .no
        txtConfirmPassword.smartQuotesType = .no
        txtConfirmPassword.keyboardType = .asciiCapable
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func signUpTapped(_ sender: UIButton) {

        let firstName = (txtFirstName.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName  = (txtLastName.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email     = (txtEmail.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let username  = (txtUsername.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password  = txtPassword.text ?? ""
        let confirmPassword = txtConfirmPassword.text ?? ""

        let fullName = "\(firstName) \(lastName)"

        // Validate empty fields
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !username.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in all fields.")
            return
        }

        // Validate email
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        // Validate password match
        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return
        }

        // Minimum password length
        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters.")
            return
        }

        // Prevent multiple taps
        btnSignUp.isEnabled = false

        // Create user in Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            self.btnSignUp.isEnabled = true

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                self.showAlert(title: "Error", message: "Could not create user.")
                return
            }

            // Save full name to FirebaseAuth profile
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName

            changeRequest.commitChanges { [weak self] commitError in
                guard let self = self else { return }

                if let commitError = commitError {
                    self.showAlert(
                        title: "Warning",
                        message: "Account created, but name could not be saved: \(commitError.localizedDescription)"
                    )
                    return
                }

                // Save locally if needed
                UserDefaults.standard.set(fullName, forKey: "currentUserFullName")
                UserDefaults.standard.set(username, forKey: "currentUsername")

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

