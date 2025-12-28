//
//  LoginViewController.swift
//  CampusCare_S3_G5
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
        email.textContentType = .username
        email.smartInsertDeleteType = .no
        email.smartDashesType = .no
        email.smartQuotesType = .no

        // Secure password field
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no

        // Helps reduce strong password/AutoFill UI (not 100% guaranteed by iOS)
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.passwordRules = nil
        passwordTextField.smartInsertDeleteType = .no
        passwordTextField.smartDashesType = .no
        passwordTextField.smartQuotesType = .no
        passwordTextField.keyboardType = .asciiCapable

        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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
        guard let enteredEmail = email.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !enteredEmail.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }

        // Validate password
        guard let enteredPassword = passwordTextField.text,
              !enteredPassword.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }

        // Prevent double taps
        loginButton.isEnabled = false

        // Firebase Sign In
        Auth.auth().signIn(withEmail: enteredEmail, password: enteredPassword) { [weak self] _, error in
            guard let self = self else { return }
            self.loginButton.isEnabled = true

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            guard let user = Auth.auth().currentUser else {
                self.showAlert(title: "Error", message: "Could not get current user.")
                return
            }

            let uid = user.uid
            let emailToSave = user.email ?? enteredEmail

            // Get fullName from FirebaseAuth profile
            let fullNameFromAuth = (user.displayName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let safeFullName = fullNameFromAuth.isEmpty ? "User" : fullNameFromAuth

            // Save/update user data in Firestore (email + fullName only)
            self.saveUserToFirestore(uid: uid, email: emailToSave, fullName: safeFullName) { [weak self] savedName, err in
                guard let self = self else { return }

                if let err = err {
                    self.showAlert(title: "Error", message: err.localizedDescription)
                    return
                }

                let alert = UIAlertController(
                    title: "Success",
                    message: "Welcome \(savedName)",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    // Navigate after login (optional)
                    // self.performSegue(withIdentifier: "goToHomePage", sender: nil)
                })

                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Navigate to Sign Up screen (optional)
        // self.performSegue(withIdentifier: "goToSignUp", sender: nil)
    }

    // MARK: - Firestore Save
    private func saveUserToFirestore(
        uid: String,
        email: String,
        fullName: String,
        completion: @escaping (_ finalFullName: String, _ error: Error?) -> Void
    ) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)

        // Prepare data to save
        let dataToSave: [String: Any] = [
            "email": email,
            "fullName": fullName,
            "lastLoginAt": Timestamp(date: Date())
        ]

        userRef.setData(dataToSave, merge: true) { err in
            if let err = err {
                completion(fullName, err)
                return
            }
            completion(fullName, nil)
        }
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
