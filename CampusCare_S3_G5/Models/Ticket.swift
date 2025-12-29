// Models/Ticket.swift
import UIKit
import Foundation

struct Ticket: Identifiable, Codable{
    let id: String
    let title: String
    let dateCommenced: Date
    let status: TicketStatus
    let priority: TicketPriority
    let tasks: [TicketTask]
    let location: String
    let issue: String
    let category:String
    let description: String
    let assignedTo: String?
    let dueDate: Date
    var isEscalated: Bool = false
    var escalationReason: String?
    
    // Computed properties
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateCommenced)
    }
    
    var tasksCount: Int {
        tasks.count
    }
    
    var pendingTasksCount: Int {
        tasks.filter { $0.status == .pending }.count
    }
}

enum TicketStatus: String, Codable, CaseIterable{
    case new = "New"
    case inProgress = "In Progress"
    case onHold = "On Hold"
    case resolved = "Resolved"
    case completed = "Completed"
    
    var color: UIColor {
        switch self {
        case .new: return .systemBlue
        case .inProgress: return .systemOrange
        case .onHold: return .systemYellow
        case .resolved: return .systemGreen
        case .completed: return .systemGray
        }
    }
}

enum TicketPriority: String, Codable{
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: UIColor {
        switch self {
        case .low: return .systemGreen
        case .medium: return .systemYellow
        case .high: return .systemOrange
        case .critical: return .systemRed
        }
    }
}
