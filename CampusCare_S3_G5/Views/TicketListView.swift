// Views/TicketListView.swift
import SwiftUI

struct TicketListView: View {
    @State private var tickets: [Ticket] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(tickets) { ticket in
                        TicketRowView(ticket: ticket) {
                            // Handle view detail action
                            viewTicketDetail(ticket)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Tickets")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadTickets()
            }
        }
    }
    
    private func loadTickets() {
        // Sample data - replace with your actual data source
        tickets = [
            Ticket(
                ticketID: "TKT-001",
                title: "Login Issue - Unable to access account",
                dateCommenced: Date().addingTimeInterval(-86400 * 2), // 2 days ago
                status: .open
            ),
            Ticket(
                ticketID: "TKT-002",
                title: "Payment processing failed",
                dateCommenced: Date().addingTimeInterval(-86400 * 1), // 1 day ago
                status: .inProgress
            ),
            Ticket(
                ticketID: "TKT-003",
                title: "App crashes on launch",
                dateCommenced: Date().addingTimeInterval(-86400 * 5),
                status: .resolved
            ),
            Ticket(
                ticketID: "TKT-004",
                title: "Feature request: Dark mode",
                dateCommenced: Date().addingTimeInterval(-86400 * 3),
                status: .open
            )
        ]
    }
    
    private func viewTicketDetail(_ ticket: Ticket) {
        // Navigate to detail view
        print("Viewing detail for ticket: \(ticket.ticketID)")
        // You would typically navigate to a detail view here
        // For example: navigationPath.append(ticket)
    }
}