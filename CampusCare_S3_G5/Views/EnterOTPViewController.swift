import UIKit
import FirebaseAuth

class EnterOTPViewController: UIViewController {

    @IBOutlet weak var otpTextField6: UITextField!
    @IBOutlet weak var otpTextField5: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    
    var verificationID: String?  // Verification ID from Firebase
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup OTP text fields to automatically focus on the next one
        setupOTPFields()

        // Display email or phone number for reference
        lblemail.text = "example@example.com"  // Update with actual value
    }

    // MARK: - Setup OTP Fields
    func setupOTPFields() {
        otpTextField1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField5.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField6.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: - OTP Text Field Handling
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 1 {
            switch textField {
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField5.becomeFirstResponder()
            case otpTextField5:
                otpTextField6.becomeFirstResponder()
            default:
                otpTextField1.becomeFirstResponder()
            }
        }
    }

    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        // Combine OTP entered into a single string
        let otp1 = otpTextField1.text ?? ""
        let otp2 = otpTextField2.text ?? ""
        let otp3 = otpTextField3.text ?? ""
        let otp4 = otpTextField4.text ?? ""
        let otp5 = otpTextField5.text ?? ""
        let otp6 = otpTextField6.text ?? ""
        
        // Concatenate OTP fields into one string
        let otp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
        
        // Check if OTP is complete
        if otp.count == 6 {
            // Verify the OTP using Firebase
            verifyOTP(otpCode: otp)
        } else {
            showAlert(title: "Invalid OTP", message: "Please enter the 6-digit code sent to your email.")
        }
    }

    @IBAction func resendCodeTapped(_ sender: Any) {
        // Resend the OTP if needed
        resendOTP()
    }

    // MARK: - Firebase OTP Verification
    func verifyOTP(otpCode: String) {
        // Firebase Authentication - Verify the OTP
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: otpCode)

        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                self?.showAlert(title: "Verification Failed", message: error.localizedDescription)
                return
            }

            // OTP verification successful
            self?.showAlert(title: "Success", message: "OTP verification successful. You can now reset your password.")
            // Optionally, navigate to the reset password page or other logic here.
        }
    }

    // MARK: - Resend OTP
    func resendOTP() {
        // Use Firebase's PhoneAuthProvider to resend the code to the user's email/phone number
        PhoneAuthProvider.provider().verifyPhoneNumber("userPhoneNumber", uiDelegate: nil) { [weak self] (verificationID, error) in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self?.verificationID = verificationID
            self?.showAlert(title: "OTP Sent", message: "A new OTP has been sent to your email/phone.")
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
