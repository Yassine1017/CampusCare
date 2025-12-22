// Models/Ticket.swift
import UIKit
import Foundation

struct Ticket: Identifiable {
    let id: String
    let title: String
    let dateCommenced: Date
    let status: TicketStatus
    let priority: TicketPriority
    let tasks: [Task]
    let location: String
    let assignedTo: String?
    
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

enum TicketStatus: String {
    case open = "Open"
    case inProgress = "In Progress"
    case onHold = "On Hold"
    case resolved = "Resolved"
    case closed = "Closed"
    
    var color: UIColor {
        switch self {
        case .open: return .systemBlue
        case .inProgress: return .systemOrange
        case .onHold: return .systemYellow
        case .resolved: return .systemGreen
        case .closed: return .systemGray
        }
    }
}

enum TicketPriority: String {
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
