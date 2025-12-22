//
//  TechnicianDashboardViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 21/12/2025.
//

import UIKit

class TechnicianDashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSampleTickets()
        populateTicketList()
        setupRefreshControl()
    }
    
    // MARK: - Outlets
        @IBOutlet weak var headerView: UIView!
        @IBOutlet weak var ticketsStackView: UIStackView!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var backButton: UIButton!
        
        // MARK: - Properties
        var tickets: [Ticket] = []
        
        // MARK: - Setup Methods
        func setupAppearance() {
            // Configure header
            headerView.backgroundColor = .systemBlue
            
            // Configure back button
            backButton.setTitleColor(.white, for: .normal)
            backButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            
            // Configure scroll view
            scrollView.showsVerticalScrollIndicator = true
            scrollView.alwaysBounceVertical = true
        }
        
        func setupSampleTickets() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Sample tasks for tickets
            let maintenanceTasks = [
                Task(title: "Inspect classroom HVAC systems", status: .pending, priority: .high),
                Task(title: "Replace air filters", status: .completed, priority: .medium),
                Task(title: "Check thermostat calibration", status: .inProgress, priority: .low)
            ]
            
            let electricalTasks = [
                Task(title: "Replace library light fixtures", status: .inProgress, priority: .medium),
                Task(title: "Inspect electrical panels", status: .pending, priority: .high),
                Task(title: "Test emergency lighting", status: .completed, priority: .high)
            ]
            
            let plumbingTasks = [
                Task(title: "Fix leaking roof in auditorium", status: .completed, priority: .high),
                Task(title: "Unclog restroom drains", status: .inProgress, priority: .medium),
                Task(title: "Inspect water heater", status: .pending, priority: .low),
                Task(title: "Replace faucet washers", status: .pending, priority: .low)
            ]
            
            let groundskeepingTasks = [
                Task(title: "Trim trees near walkways", status: .pending, priority: .low),
                Task(title: "Mow athletic fields", status: .inProgress, priority: .medium),
                Task(title: "Maintain irrigation system", status: .inProgress, priority: .medium),
                Task(title: "Plant seasonal flowers", status: .completed, priority: .low)
            ]
            
            let safetyTasks = [
                Task(title: "Test fire extinguishers", status: .completed, priority: .high),
                Task(title: "Inspect emergency exits", status: .pending, priority: .high),
                Task(title: "Update safety signage", status: .inProgress, priority: .medium)
            ]
            
            // Create sample tickets
            tickets = [
                Ticket(id: "TKT-2024-001",
                       title: "Campus HVAC Maintenance",
                       dateCommenced: dateFormatter.date(from: "2024-01-15") ?? Date(),
                       status: .inProgress,
                       priority: .medium, // Add priority
                       tasks: maintenanceTasks,
                       location: "Science Building", // Add location
                       assignedTo: "John Smith"), // Add assignedTo
                
                Ticket(id: "TKT-2024-002",
                       title: "Electrical System Upgrade",
                       dateCommenced: dateFormatter.date(from: "2024-01-20") ?? Date(),
                       status: .open,
                       priority: .high,
                       tasks: electricalTasks,
                       location: "Main Building",
                       assignedTo: "Sarah Johnson"),
                
                Ticket(id: "TKT-2024-003",
                       title: "Plumbing Repairs - Auditorium",
                       dateCommenced: dateFormatter.date(from: "2024-01-10") ?? Date(),
                       status: .inProgress,
                       priority: .high,
                       tasks: plumbingTasks,
                       location: "Auditorium",
                       assignedTo: "Mike Chen"),
                
                Ticket(id: "TKT-2024-004",
                       title: "Groundskeeping & Landscaping",
                       dateCommenced: dateFormatter.date(from: "2024-01-05") ?? Date(),
                       status: .open,
                       priority: .low,
                       tasks: groundskeepingTasks,
                       location: "Main Campus Grounds",
                       assignedTo: "Grounds Team"),
                
                Ticket(id: "TKT-2024-005",
                       title: "Campus Safety Inspection",
                       dateCommenced: dateFormatter.date(from: "2024-01-18") ?? Date(),
                       status: .resolved,
                       priority: .medium,
                       tasks: safetyTasks,
                       location: "All Buildings",
                       assignedTo: "Safety Office"),
                
                Ticket(id: "TKT-2023-125",
                       title: "Classroom Furniture Replacement",
                       dateCommenced: dateFormatter.date(from: "2023-12-01") ?? Date(),
                       status: .closed,
                       priority: .medium,
                       tasks: [
                        Task(title: "Replace broken desks", status: .completed, priority: .medium),
                        Task(title: "Install whiteboards", status: .completed, priority: .low),
                        Task(title: "Repair chairs", status: .completed, priority: .low)
                       ],
                       location: "Classroom 101",
                       assignedTo: "Facilities Team")
            ]
        }
        
        func populateTicketList() {
            // Clear existing views (except first 3 which are static)
            let arrangedSubviews = ticketsStackView.arrangedSubviews
            for view in arrangedSubviews.dropFirst(3) {
                ticketsStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            // Add ticket cards
            for ticket in tickets {
                let ticketCard = createTicketCard(for: ticket)
                ticketsStackView.addArrangedSubview(ticketCard)
            }
            
            // Add empty state if no tickets
            if tickets.isEmpty {
                let emptyLabel = UILabel()
                emptyLabel.text = "No tickets found"
                emptyLabel.textAlignment = .center
                emptyLabel.font = .systemFont(ofSize: 18, weight: .medium)
                emptyLabel.textColor = .secondaryLabel
                emptyLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
                ticketsStackView.addArrangedSubview(emptyLabel)
            }
        }
        
        func createTicketCard(for ticket: Ticket) -> UIView {
            // Container View
            let containerView = UIView()
            containerView.backgroundColor = .systemBackground
            containerView.layer.cornerRadius = 12
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowOpacity = 0.1
            containerView.layer.masksToBounds = false
            
            // Vertical Stack View
            let verticalStack = UIStackView()
            verticalStack.axis = .vertical
            verticalStack.spacing = 12
            verticalStack.alignment = .fill
            verticalStack.translatesAutoresizingMaskIntoConstraints = false
            
            // Top Row: Ticket ID + Status
            let topRowStack = UIStackView()
            topRowStack.axis = .horizontal
            topRowStack.distribution = .equalSpacing
            topRowStack.alignment = .center
            
            let idLabel = UILabel()
            idLabel.text = ticket.id
            idLabel.font = .systemFont(ofSize: 16, weight: .bold)
            idLabel.textColor = .systemBlue
            
            let statusView = UIView()
            statusView.backgroundColor = ticket.status.color
            statusView.layer.cornerRadius = 4
            statusView.widthAnchor.constraint(equalToConstant: 8).isActive = true
            statusView.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
            topRowStack.addArrangedSubview(idLabel)
            topRowStack.addArrangedSubview(statusView)
            
            // Title Label
            let titleLabel = UILabel()
            titleLabel.text = ticket.title
            titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            titleLabel.textColor = .label
            titleLabel.numberOfLines = 2
            titleLabel.minimumScaleFactor = 0.8
            titleLabel.adjustsFontSizeToFitWidth = true
            
            // Date Label
            let dateLabel = UILabel()
            dateLabel.text = "Commenced: \(ticket.formattedDate)"
            dateLabel.font = .systemFont(ofSize: 14)
            dateLabel.textColor = .secondaryLabel
            
            
            // Button Row
            let buttonRowStack = UIStackView()
            buttonRowStack.axis = .horizontal
            buttonRowStack.distribution = .fill
            
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            
            let detailButton = UIButton(type: .system)
            detailButton.setTitle("View Details", for: .normal)
            detailButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            detailButton.setTitleColor(.systemBlue, for: .normal)
            detailButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            detailButton.layer.cornerRadius = 8
            detailButton.addTarget(self, action: #selector(viewDetailTapped(_:)), for: .touchUpInside)
            
            // Store ticket ID in button for identification
            detailButton.accessibilityIdentifier = ticket.id
            
            buttonRowStack.addArrangedSubview(spacer)
            buttonRowStack.addArrangedSubview(detailButton)
            
            // Add subviews to vertical stack
            verticalStack.addArrangedSubview(topRowStack)
            verticalStack.addArrangedSubview(titleLabel)
            verticalStack.addArrangedSubview(dateLabel)
            verticalStack.addArrangedSubview(buttonRowStack)
            
            // Add to container
            containerView.addSubview(verticalStack)
            
            // Constraints
            NSLayoutConstraint.activate([
                verticalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                verticalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                verticalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                verticalStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
                
                containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140),
                detailButton.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            return containerView
        }
        
        func setupRefreshControl() {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshTicketList), for: .valueChanged)
            refreshControl.tintColor = .systemBlue
            scrollView.refreshControl = refreshControl
        }
        
        // MARK: - Actions
        @IBAction func backButtonTapped(_ sender: UIButton) {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        
        @objc func viewDetailTapped(_ sender: UIButton) {
            guard let ticketID = sender.accessibilityIdentifier,
                  let ticket = tickets.first(where: { $0.id == ticketID }) else {
                return
            }
            
            // Show ticket detail
            let alert = UIAlertController(
                title: ticket.title,
                message: """
                ID: \(ticket.id)
                Status: \(String(describing: ticket.status))
                Date: \(ticket.formattedDate)
                
                Tasks:
                \(ticket.tasks.map { "• \($0.title) (\($0.status))" }.joined(separator: "\n"))
                """,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            // In a real app, you would navigate to a detail view controller:
            // let detailVC = TicketDetailViewController(ticket: ticket)
            // navigationController?.pushViewController(detailVC, animated: true)
        }
        
        @objc func refreshTicketList() {
            // Simulate network refresh
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.scrollView.refreshControl?.endRefreshing()
                // In a real app, fetch new data here
            }
        }
    }
    
