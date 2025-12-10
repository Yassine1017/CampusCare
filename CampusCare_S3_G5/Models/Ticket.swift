// Models/Ticket.swift
import Foundation

struct Ticket: Identifiable {
    let id: UUID
    let ticketID: String
    let title: String
    let dateCommenced: Date
    let status: TicketStatus
    
    init(ticketID: String, title: String, dateCommenced: Date, status: TicketStatus = .open) {
        self.id = UUID()
        self.ticketID = ticketID
        self.title = title
        self.dateCommenced = dateCommenced
        self.status = status
    }
}

enum TicketStatus {
    case open
    case inProgress
    case resolved
    
    var colorName: String {
        switch self {
        case .open: return "orange"
        case .inProgress: return "blue"
        case .resolved: return "green"
        }
    }
}