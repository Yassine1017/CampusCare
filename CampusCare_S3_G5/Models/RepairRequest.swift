//
//  User.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-18 on 03/12/2025.
//


import Foundation
import FirebaseFirestore

struct RepairRequest: Identifiable, Codable {
    
    // Firestore document ID
    var id: String
    
    // Request details
    let issue: String
    let description: String
    let location: String
    
    // Status
    let status: RequestStatus
    
    // User & technician info
    let userId: String
    let technicianName: String?
    
    // Dates
    let createdAt: Timestamp
    let assignmentDate: Timestamp?
    
    // Optional notes
    let notes: [RequestNote]?
}

enum RequestStatus: String, Codable {
    case new = "New"
    case inProgress = "In Progress"
    case completed = "Completed"
}

struct RequestNote: Codable {
    let message: String
    let date: Timestamp
}



