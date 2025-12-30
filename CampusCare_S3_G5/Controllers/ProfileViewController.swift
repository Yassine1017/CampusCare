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

        // Email always comes from Firebase Auth
        emailTextField.isUserInteractionEnabled = false
        emailTextField.textColor = .secondaryLabel

        // Optional hint
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

        // Email from Firebase Auth
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
                self.nameTextField.text = data["fullName"] as? String
                self.phoneTextField.text = data["phone"] as? String ?? ""
            }
        }
    }


    // MARK: - Edit Profile
    @IBAction func editProfileTapped(_ sender: UIButton) {

        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid

        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your name")
            return
        }

        var updatedData: [String: Any] = [
            "name": name
        ]

        // Phone is optional
        if let phone = phoneTextField.text, !phone.isEmpty {
            updatedData["phone"] = phone
        } else {
            // Remove phone field if empty
            updatedData["phone"] = FieldValue.delete()
        }

        db.collection("users").document(uid).updateData(updatedData) { error in
            if let error = error {
                print("Error updating profile:", error)
                self.showAlert(title: "Error", message: "Could not update profile")
                return
            }

            self.showAlert(title: "Success", message: "Profile updated successfully")
        }
    }

    // MARK: - Alert Helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
