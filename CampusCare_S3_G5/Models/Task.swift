//
//  Task.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 08/12/2025.
//

import Foundation

enum TaskStatus {
    case pending
    case inProgress
    case completed
}

enum TaskPriority {
    case low
    case medium
    case high
}

struct Task {
    let title: String
    let status: TaskStatus
    let priority: TaskPriority
}
