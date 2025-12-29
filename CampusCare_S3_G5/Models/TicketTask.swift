//
//  Task.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 08/12/2025.
//



struct TicketTask: Identifiable, Codable {
    let id: String
    let title: String
    let status: TicketTaskStatus
    let priority: TicketTaskPriority
}

enum TicketTaskStatus: String, Codable {
    case pending
    case inProgress
    case completed
}

enum TicketTaskPriority: String, Codable {
    case low
    case medium
    case high
}
