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
        // Password field
        txtPassword.isSecureTextEntry = true
        txtPassword.textContentType = nil
        txtPassword.passwordRules = nil
        txtPassword.autocorrectionType = .no
        txtPassword.autocapitalizationType = .none
        txtPassword.smartInsertDeleteType = .no
        txtPassword.smartDashesType = .no
        txtPassword.smartQuotesType = .no

        // Confirm password field
        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.textContentType = nil
        txtConfirmPassword.passwordRules = nil
        txtConfirmPassword.autocorrectionType = .no
        txtConfirmPassword.autocapitalizationType = .none
        txtConfirmPassword.smartInsertDeleteType = .no
        txtConfirmPassword.smartDashesType = .no
        txtConfirmPassword.smartQuotesType = .no

    }

    // MARK: - TextField Configuration
    private func configureTextFields() {

        // Full name field
        txtFullName.autocapitalizationType = .words
        txtFullName.autocorrectionType = .no
        txtFullName.textContentType = .name
        txtFullName.smartInsertDeleteType = .no
        txtFullName.smartDashesType = .no
        txtFullName.smartQuotesType = .no

        // Email field
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no
        txtEmail.textContentType = .emailAddress
        txtEmail.smartInsertDeleteType = .no
        txtEmail.smartDashesType = .no
        txtEmail.smartQuotesType = .no

        // Username field
        txtUsername.autocapitalizationType = .none
        txtUsername.autocorrectionType = .no
        txtUsername.textContentType = .username
        txtUsername.smartInsertDeleteType = .no
        txtUsername.smartDashesType = .no
        txtUsername.smartQuotesType = .no
    }

    // MARK: - Password Configuration
    private func configurePasswordFields() {

        // IMPORTANT:
        // iOS may still show "Strong Password" in some cases because it's controlled by the OS.
        // These settings attempt to disable AutoFill/password suggestions as much as possible.

        // Password
        txtPassword.isSecureTextEntry = true
        txtPassword.autocapitalizationType = .none
        txtPassword.autocorrectionType = .no

        // Avoid `.newPassword` (it strongly triggers "Strong Password")
        // Using nil removes AutoFill hints in many cases.
        txtPassword.textContentType = nil

        // Remove any password rules that may suggest strong passwords
        txtPassword.passwordRules = nil

        // Disable smart typing features
        txtPassword.smartInsertDeleteType = .no
        txtPassword.smartDashesType = .no
        txtPassword.smartQuotesType = .no

        // Confirm Password
        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.autocapitalizationType = .none
        txtConfirmPassword.autocorrectionType = .no
        txtConfirmPassword.textContentType = nil
        txtConfirmPassword.passwordRules = nil
        txtConfirmPassword.smartInsertDeleteType = .no
        txtConfirmPassword.smartDashesType = .no
        txtConfirmPassword.smartQuotesType = .no

        // Optional:
        // If you still see suggestions, you can also try:
        // txtPassword.keyboardType = .asciiCapable
        // txtConfirmPassword.keyboardType = .asciiCapable
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

        let fullName = (txtFullName.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email = (txtEmail.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let username = (txtUsername.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = txtPassword.text ?? ""
        let confirmPassword = txtConfirmPassword.text ?? ""

        // Validate empty fields
        guard !fullName.isEmpty,
              !email.isEmpty,
              !username.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in all fields.")
            return
        }

        // Validate email format
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        // Validate password match
        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return
        }

        // Minimum password length (Firebase usually requires at least 6)
        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters.")
            return
        }

        // Prevent double taps
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

            // Set display name to full name (optional)
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            changeRequest.commitChanges { _ in
                // Ignore errors; Firestore still stores fullName.
            }

            let db = Firestore.firestore()
            let userRef = db.collection("users").document(user.uid)

            // Save user profile in Firestore (NO EMAIL SENDING)
            let userData: [String: Any] = [
                "fullName": fullName,
                "username": username,
                "email": email,
                "role": "student",
                "createdAt": Timestamp(date: Date()),
                "firstLoginAt": FieldValue.delete(),
                "firstLoginEmailSent": false,
                "lastLoginAt": FieldValue.delete(),
                "loginCount": 0
            ]

            userRef.setData(userData, merge: true) { [weak self] err in
                guard let self = self else { return }

                if let err = err {
                    self.showAlert(title: "Error", message: err.localizedDescription)
                    return
                }

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

