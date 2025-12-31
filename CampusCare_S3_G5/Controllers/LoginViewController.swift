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

    private let db = Firestore.firestore()

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

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            self.loginButton.isEnabled = true

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else { return }
            self.routeUser(uid: uid)
        }
    }

    // MARK: - Role routing (UIKit way)

    private func routeUser(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            let role = snapshot?.data()?["role"] as? String ?? "user"

            DispatchQueue.main.async {
                switch role {
                case "technician":
                    self.switchStoryboard(name: "Technician")
                case "admin":
                    self.switchStoryboard(name: "Admin")
                default:
                    self.switchStoryboard(name: "RepairRequestSystem")
                }
            }
        }
    }

    private func switchStoryboard(name: String) {

        guard
            let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else {
            print("❌ Could not get SceneDelegate window")
            return
        }

        let storyboard = UIStoryboard(name: name, bundle: nil)

        guard let vc = storyboard.instantiateInitialViewController() else {
            fatalError("Storyboard \(name) has no initial view controller")
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
    }


    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

