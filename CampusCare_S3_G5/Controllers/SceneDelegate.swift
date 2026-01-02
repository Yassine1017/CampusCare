//
//  SceneDelegate.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-18 on 03/12/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AccountType: String {
    case user
    case technician
    case admin
}

final class SessionManager {

    // 🔔 SceneDelegate listens to this
    var onRoleResolved: ((AccountType?) -> Void)?

    private let db = Firestore.firestore()

    /// Start listening to Firebase Auth state
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                self.fetchUserRole(uid: user.uid)
            } else {
                // Not logged in → show login
                self.onRoleResolved?(nil)
            }
        }
    }

    /// Fetch role from Firestore
    private func fetchUserRole(uid: String) {
        db.collection("users")
            .document(uid)
            .getDocument { [weak self] snapshot, _ in
                guard let self = self else { return }

                let roleString = snapshot?.data()?["role"] as? String
                let role = AccountType(rawValue: roleString ?? "")

                // 🔔 Notify SceneDelegate
                self.onRoleResolved?(role)
            }
    }
}
