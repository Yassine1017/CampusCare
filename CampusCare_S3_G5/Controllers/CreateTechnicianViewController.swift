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
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Technician"
        view.backgroundColor = .systemBackground
        createButton.layer.cornerRadius = 8
    }

    @IBAction func createButtonTapped(_ sender: UIButton) {

        // 1. Updated validation to include the passwordField
            guard
                let firstName = firstNameField.text, !firstName.isEmpty,
                let lastName = lastNameField.text, !lastName.isEmpty,
                let specialization = specializationField.text, !specialization.isEmpty,
                let email = emailField.text, !email.isEmpty,
                let password = passwordField.text, !password.isEmpty
            else {
                showAlert("Missing Information", "All fields including password are required.")
                return
            }

            // 2. Create the user in Firebase Auth using the password from the IBOutlet
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

                if let error = error {
                    self.showAlert("Auth Error", error.localizedDescription)
                    return
                }

                guard let uid = authResult?.user.uid else {
                    self.showAlert("Error", "Failed to get user ID")
                    return
                }

                // 3. Save technician data to Firestore
                // Including "id" ensures compatibility with your User model
                let userData: [String: Any] = [
                    "id": uid,
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

                        // 4. Success handling
                        let successMessage = """
                        Technician account created successfully.
                        
                        Email: \(email)
                        Password: \(password)
                        """

                        let alert = UIAlertController(title: "Success", message: successMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true)
                    }
            }
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
