//
//  Feedback.swift
//  CampusCare_S3_G5
//
//  Created by Guest User on 25/12/2025.
//

import Foundation
import FirebaseFirestore

struct Feedback: Identifiable, Codable {

    // Firestore document ID
    var id: String

    // Relationships
    let requestId: String          // repairRequests/{requestId}
    let userId: String             // users/{uid}
    let technicianId: String       // technicians/{uid}

    // Names (snapshot at time of feedback)
    let userFirstName: String
    let userLastName: String
    let technicianFirstName: String
    let technicianLastName: String

    // Feedback content
    let rating: Int                // 1–5
    let comment: String?

    // Date
    let createdAt: Timestamp
}
