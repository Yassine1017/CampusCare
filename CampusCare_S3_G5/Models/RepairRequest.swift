//
//  User.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-18 on 03/12/2025.
//


import Foundation

struct RepairRequest {
    let id: Int
    let issue: String
    let status: Status
    let assignmentDate: Date?
    let technicianName: String?
    let category: String
    let notes: [RequestNote]
}

enum Status: String {
    case new = "New"
    case inProgress = "In Progress"
    case completed = "Completed"
}
struct RequestNote {
    let message: String
    let date: Date
}



