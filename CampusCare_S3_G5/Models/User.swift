//
//  User.swift
//  CampusCare_S3_G5
//
//  Created by Guest User on 25/12/2025.
//

import Foundation
import FirebaseFirestore

enum UserRole: String, Codable {
    case user = "user"
    case technician = "technician"
    case admin = "admin"
}

struct User: Identifiable, Codable {
    // Firestore document ID (Firebase Auth UID)
    var id: String

    // Shared Name & Contact info
    let firstName: String
    let lastName: String
    let email: String

    // Role-based Attribute
    let role: UserRole

    // Technician specific (moved from Technician.swift)
    let specialization: String?

    // Metadata
    let createdAt: Timestamp
    var lastLogin: Timestamp?
}
