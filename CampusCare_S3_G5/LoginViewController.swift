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
    @IBOutlet weak var txtEmail: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no

        passwordTextField.isSecureTextEntry = true

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tapGesture)

        title = "Login"
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        guard let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            showAlert(title: "Error", message: "Email and password are required.")
            return
        }

        loginButton.isEnabled = false

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            self.loginButton.isEnabled = true

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            guard let authUser = Auth.auth().currentUser else {
                self.showAlert(title: "Error", message: "User not found.")
                return
            }

            self.handleSuccessfulLogin(user: authUser)
        }
    }

    // ✅ Register button enabled – no alert, no crash
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Intentionally left empty
        // Will be connected to SignUpViewController later
    }

    // MARK: - Handle Login Success
    private func handleSuccessfulLogin(user: FirebaseAuth.User) {

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        let email = user.email ?? ""

        let displayName = (user.displayName ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let nameParts = displayName.split(separator: " ")
        let firstName = nameParts.first.map(String.init) ?? "User"
        let lastName  = nameParts.dropFirst().joined(separator: " ")

        let now = Timestamp(date: Date())

        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            let data = snapshot?.data()
            let role = data?["role"] as? String ?? "user"
            let loginAt = data?["loginAt"] as? Timestamp ?? now

            let dataToSave: [String: Any] = [
                "email": email,
                "firstName": firstName,
                "lastName": lastName,
                "loginAt": loginAt,
                "lastLogin": now
            ]

            userRef.setData(dataToSave, merge: true) { _ in
                let message = role == "admin"
                    ? "Login successful. Welcome Admin!"
                    : "Login successful. Welcome!"

                self.showAlert(title: "Success", message: message)
            }
        }
    }

    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
