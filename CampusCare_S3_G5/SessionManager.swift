import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AccountType: String {
    case user
    case technician
    case admin
}

final class SessionManager {

    // 🚨 THIS MUST EXIST
    var onRoleResolved: ((AccountType?) -> Void)?

    private let db = Firestore.firestore()

    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                self.fetchUserRole(uid: user.uid)
            } else {
                self.onRoleResolved?(nil)
            }
        }
    }

    private func fetchUserRole(uid: String) {
        db.collection("users")
            .document(uid)
            .getDocument { [weak self] snapshot, _ in
                guard let self = self else { return }

                let roleString = snapshot?.data()?["role"] as? String
                let role = AccountType(rawValue: roleString ?? "")

                self.onRoleResolved?(role)
            }
    }
}
