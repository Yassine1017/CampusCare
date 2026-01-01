import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!

    let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserProfile()
    }

    // MARK: - UI Setup
    func setupUI() {
        navigationItem.title = "Profile"

        emailTextField.isUserInteractionEnabled = false
        emailTextField.textColor = .secondaryLabel

        phoneTextField.placeholder = "Optional"

        editProfileButton.layer.cornerRadius = 10
    }

    // MARK: - Fetch User Profile
    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else {
            print("No logged-in user")
            return
        }

        let uid = user.uid
        emailTextField.text = user.email

        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Firestore error:", error)
                return
            }

            guard let data = snapshot?.data() else {
                print("User document exists but has no data")
                return
            }

            DispatchQueue.main.async {
                let firstName = data["firstName"] as? String ?? ""
                let lastName  = data["lastName"] as? String ?? ""

                self.nameTextField.text =
                    "\(firstName) \(lastName)"
                        .trimmingCharacters(in: .whitespaces)

                self.phoneTextField.text =
                    data["phone"] as? String ?? ""
            }
        }
    }

    // MARK: - Edit Profile (FIXED)
    @IBAction func editProfileTapped(_ sender: UIButton) {

        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid

        guard
            let fullName = nameTextField.text, !fullName.isEmpty,
            let email = emailTextField.text, !email.isEmpty
        else {
            showAlert(title: "Missing Info", message: "Name and email are required.")
            return
        }

        // Split name into first & last
        let parts = fullName.split(separator: " ", maxSplits: 1)
        let firstName = String(parts.first ?? "")
        let lastName = parts.count > 1 ? String(parts[1]) : ""

        var updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName
        ]

        // Phone optional
        if let phone = phoneTextField.text, !phone.isEmpty {
            updatedData["phone"] = phone
        } else {
            updatedData["phone"] = FieldValue.delete()
        }

        // Update email in Firebase Auth if changed
        if email != user.email {
            user.sendEmailVerification(beforeUpdatingEmail: email) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }

                self.showAlert(
                    title: "Verify Your Email",
                    message: "A verification email was sent to \(email). Your email will be updated after verification."
                )

                // Update Firestore immediately (name / phone)
                self.updateUserFirestore(uid: uid, data: updatedData)
            }
        }
 else {
            updateUserFirestore(uid: uid, data: updatedData)
        }
    }

    // MARK: - Firestore Update Helper
    private func updateUserFirestore(uid: String, data: [String: Any]) {

        db.collection("users").document(uid).updateData(data) { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self.showAlert(title: "Success", message: "Profile updated successfully")
        }
    }

    // MARK: - Alert Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    @IBAction func signOutTapped(_ sender: UIButton) {

        do {
            try Auth.auth().signOut()
        } catch {
            showAlert(title: "Error", message: "Failed to sign out.")
            return
        }

        // Go back to Login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let loginVC = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as? UIViewController else {
            return
        }

        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen

        // Replace root view controller (no back navigation)
        view.window?.rootViewController = nav
        view.window?.makeKeyAndVisible()
    }

}
