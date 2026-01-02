//
//  SignUpViewController.swift
//  CampusCare_S3_G5
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
            txtFirstName.autocapitalizationType = .words
            txtFirstName.autocorrectionType = .no
            txtFirstName.textContentType = .givenName

            txtLastName.autocapitalizationType = .words
            txtLastName.autocorrectionType = .no
            txtLastName.textContentType = .familyName

            txtEmail.keyboardType = .emailAddress
            txtEmail.autocapitalizationType = .none
            txtEmail.textContentType = .emailAddress

            txtUsername.autocapitalizationType = .none
            txtUsername.textContentType = .username
        }

        private func configurePasswordFields() {
            // Enable secure text entry
                txtPassword.isSecureTextEntry = true
                txtConfirmPassword.isSecureTextEntry = true

                // Disable iOS Strong Password and AutoFill suggestions
                txtPassword.textContentType = .oneTimeCode
                txtConfirmPassword.textContentType = .oneTimeCode

                // Disable autocorrection and spell checking
                txtPassword.autocorrectionType = .no
                txtConfirmPassword.autocorrectionType = .no
                txtPassword.spellCheckingType = .no
                txtConfirmPassword.spellCheckingType = .no
        }

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
            let password  = txtPassword.text ?? ""
            let confirmPassword = txtConfirmPassword.text ?? ""

            // Validate empty fields
            guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                showAlert(title: "Missing Information", message: "Please fill in all fields.")
                return
            }

            guard isValidEmail(email) else {
                showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
                return
            }

            guard password == confirmPassword else {
                showAlert(title: "Password Mismatch", message: "Passwords do not match.")
                return
            }

            btnSignUp.isEnabled = false

            // 1. Create user in Firebase Auth
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }

                if let error = error {
                    self.btnSignUp.isEnabled = true
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }

                guard let authUser = result?.user else {
                    self.btnSignUp.isEnabled = true
                    return
                }

                // 2. Prepare user profile data for Firestore
                // We assign the auth UID to 'id' and set the default role to 'user'
                let userData: [String: Any] = [
                    "id": authUser.uid,
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "role": "user",
                    "createdAt": Timestamp(date: Date())
                ]

                // 3. Save to Firestore 'users' collection
                let db = Firestore.firestore()
                db.collection("users").document(authUser.uid).setData(userData) { error in
                    self.btnSignUp.isEnabled = true
                    
                    if let error = error {
                        self.showAlert(title: "Database Error", message: "Account created but profile failed: \(error.localizedDescription)")
                        return
                    }

                    // 4. Update Auth Display Name
                    let changeRequest = authUser.createProfileChangeRequest()
                    changeRequest.displayName = "\(firstName) \(lastName)"
                    changeRequest.commitChanges { _ in
                        self.showSuccessAlert()
                    }
                }
            }
        }

        // MARK: - Helpers
        private func showSuccessAlert() {
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

