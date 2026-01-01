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
        // 1. Fetch the document using the User model
        db.collection("users").document(uid).getDocument(as: User.self) { [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let loggedInUser):
                DispatchQueue.main.async {
                    // --- ADDED WELCOME ALERT HERE ---
                    let alert = UIAlertController(title: "Success", message: "Welcome back!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        // 2. Pass the decoded user object to the storyboard switcher after alert is dismissed
                        self.switchStoryboard(name: self.getStoryboardName(for: loggedInUser.role), user: loggedInUser)
                    })
                    self.present(alert, animated: true)
                    // --- END OF ALERT ---
                }
            case .failure(let error):
                print("Decoding Error: \(error)")
                self.showAlert(title: "Error", message: "User profile mismatch.")
            }
        }
    }

    // Helper to determine storyboard name based on role
    private func getStoryboardName(for role: UserRole) -> String {
        switch role {
        case .technician: return "TechnicianUserPages"
        case .admin: return "AdminDashboard"
        case .user: return "RepairRequestSystem"
        }
    }

    private func switchStoryboard(name: String, user: User) {
        guard let window = view.window?.windowScene?.delegate as? SceneDelegate,
              let windowRef = window.window else { return }

        let storyboard = UIStoryboard(name: name, bundle: nil)
        let initialVC = storyboard.instantiateInitialViewController()

        // 3. Inject the User object so TechnicianTaskViewController uses live data
        if let nav = initialVC as? UINavigationController,
           let techVC = nav.viewControllers.first as? TechnicianTaskViewController {
            techVC.user = user
        } else if let techVC = initialVC as? TechnicianTaskViewController {
            techVC.user = user
        }

        windowRef.rootViewController = initialVC
        windowRef.makeKeyAndVisible()
    }


    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // This performs the segue to the Sign Up screen
        performSegue(withIdentifier: "showSignUp", sender: self)
    }
}
