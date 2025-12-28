//
//  ForgotPasswordViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 18/12/2025.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btSubmit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!

    private var activityIndicator: UIActivityIndicatorView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure email text field
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocapitalizationType = .none
        txtEmail.autocorrectionType = .no

        navigationItem.title = "Forgot Password"

        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        setupLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        view.endEditing(true)

        let email = txtEmail.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // 1) Empty check
        guard !email.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter your email address.")
            return
        }

        // 2) Format check
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        // UI: disable + show loading
        setLoading(true)

        // Optional: set email language (use "en" or "ar")
        Auth.auth().languageCode = "en"   // or: "ar"
        // Or use device language:
        // Auth.auth().useAppLanguage()

        // 3) Send reset email
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.setLoading(false)

                if let error = error {
                    let message = self.humanReadableAuthError(error)
                    self.showAlert(title: "Error", message: message)
                    return
                }

                // Success
                let alert = UIAlertController(
                    title: "Password Reset",
                    message: "A password reset link has been sent to your email. Please check your inbox (and Spam).",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })

                self.present(alert, animated: true)
            }
        }
    }

    // MARK: - Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Loading UI
    private func setupLoadingIndicator() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        self.activityIndicator = indicator
    }

    private func setLoading(_ isLoading: Bool) {
        btSubmit.isEnabled = !isLoading
        txtEmail.isEnabled = !isLoading

        if isLoading {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func humanReadableAuthError(_ error: Error) -> String {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return error.localizedDescription
        }

        switch code {
        case .invalidEmail:
            return "This email address is not valid."
        case .userNotFound:
            return "No account was found with this email."
        case .networkError:
            return "Network error. Please check your internet connection and try again."
        case .tooManyRequests:
            return "Too many requests. Please wait a bit and try again."
        default:
            return error.localizedDescription
        }
    }
}
