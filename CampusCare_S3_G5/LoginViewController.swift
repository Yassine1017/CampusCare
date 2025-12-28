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

        // Secure password field
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password

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

            guard let uid = Auth.auth().currentUser?.uid else {
                self.showAlert(title: "Error", message: "Could not get user id.")
                return
            }

            // Fetch user data (fullName/role) and update login stats (NO EMAIL SENDING)
            self.fetchUserAndUpdateLoginStats(uid: uid) { [weak self] fullName, role, err in
                guard let self = self else { return }

                if let err = err {
                    self.showAlert(title: "Error", message: err.localizedDescription)
                    return
                }

                // Use fullName for welcome message
                let nameToShow = fullName.isEmpty ? "User" : fullName
                let msg = "Welcome \(nameToShow)"

                let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    // Navigate based on role (optional)
                    // if role == "admin" {
                    //     self.performSegue(withIdentifier: "goToAdminHome", sender: nil)
                    // } else {
                    //     self.performSegue(withIdentifier: "goToHomePage", sender: nil)
                    // }
                })
                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Navigate to Sign Up screen (optional)
        // self.performSegue(withIdentifier: "goToSignUp", sender: nil)
    }

    // MARK: - Firestore (Read fullName + update login stats)
    private func fetchUserAndUpdateLoginStats(
        uid: String,
        completion: @escaping (_ fullName: String, _ role: String, _ error: Error?) -> Void
    ) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)

        // Update login stats first (safe even if some fields are missing)
        let now = Timestamp(date: Date())
        userRef.setData([
            "lastLoginAt": now,
            "loginCount": FieldValue.increment(Int64(1))
        ], merge: true) { [weak self] err in
            guard self != nil else { return }

            if let err = err {
                completion("", "student", err)
                return
            }

            // Then fetch fullName and role for welcome message
            userRef.getDocument { snapshot, error in
                if let error = error {
                    completion("", "student", error)
                    return
                }

                let data = snapshot?.data() ?? [:]
                let fullName = data["fullName"] as? String ?? ""
                let role = data["role"] as? String ?? "student"
                completion(fullName, role, nil)
            }
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

