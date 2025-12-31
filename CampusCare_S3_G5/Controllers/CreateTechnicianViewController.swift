import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateTechnicianViewController: UIViewController {

    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var specializationField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Technician"
        view.backgroundColor = .systemBackground
        createButton.layer.cornerRadius = 8
    }

    @IBAction func createButtonTapped(_ sender: UIButton) {

        guard
            let firstName = firstNameField.text, !firstName.isEmpty,
            let lastName = lastNameField.text, !lastName.isEmpty,
            let specialization = specializationField.text, !specialization.isEmpty,
            let email = emailField.text, !email.isEmpty
        else {
            showAlert("Missing Information",
                      "All fields except phone are required.")
            return
        }

        // 1. Generate temporary password
        let tempPassword = UUID().uuidString.prefix(8)
        let password = String(tempPassword)

        // 2. Create Auth user
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

            if let error = error {
                self.showAlert("Auth Error", error.localizedDescription)
                return
            }

            guard let uid = authResult?.user.uid else {
                self.showAlert("Error", "Failed to get user ID")
                return
            }

            // 3. Save technician as USER in Firestore
            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "role": "technician",              
                "specialization": specialization,
                "createdAt": Timestamp(date: Date()),
                "lastLogin": NSNull()
            ]

            Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(userData) { error in

                    if let error = error {
                        self.showAlert("Database Error", error.localizedDescription)
                        return
                    }

                    // Send password reset email
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            print("Email not sent:", error.localizedDescription)
                        }
                    }

                    self.showAlert(
                        "Technician Created",
                        """
                        Account created successfully.

                        Login email sent to:
                        \(email)
                        """
                    )

                    self.navigationController?.popViewController(animated: true)
                }
        }
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
