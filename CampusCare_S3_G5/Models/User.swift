//
//  User.swift
//  CampusCare_S3_G5
//
//  Created by Guest User on 25/12/2025.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {

    // Firestore document ID (Firebase Auth UID)
    var id: String

    // Name
    let firstName: String
    let lastName: String

    // Student details
    let email: String
    let studentId: String?

    // Optional contact info
    let phone: String?

    // Dates
    let createdAt: Timestamp
}
