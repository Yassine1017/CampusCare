//
//  Task.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 08/12/2025.
//

enum TaskStatus: String {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
}

enum TaskPriority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Task {
    let title: String
    let status: TaskStatus
    let priority: TaskPriority
}
