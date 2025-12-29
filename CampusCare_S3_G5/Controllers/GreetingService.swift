import UIKit

class GreetingService {
    
    // Function to show the Welcome Message
    static func showWelcome(on vc: UIViewController, userName: String, role: String) {
        let alert = UIAlertController(
            title: "Welcome Back!",
            message: "Hello \(userName), you are logged in as \(role).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Get Started", style: .default))
        vc.present(alert, animated: true)
    }
    
    // Function to show the Goodbye Message
    static func showGoodbye(on vc: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Logging Out",
            message: "Goodbye! Have a great day.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion() // This runs the logout transition after clicking OK
        })
        vc.present(alert, animated: true)
    }
}
