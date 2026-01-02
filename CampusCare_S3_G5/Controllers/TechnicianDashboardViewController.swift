//
//  TechnicianDashboardViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 21/12/2025.
//

import UIKit
import FirebaseAuth // ✅ REQUIRED: To get the currently logged-in technician's ID

class TechnicianDashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var allTickets: [Ticket] = [] // Holds every ticket passed from TechnicianTaskViewController
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Requests" // Explicitly setting title for the main dashboard
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // Filter out any tickets that have been marked as completed
        // This ensures that when you 'pop' back from the detail view,
        // the completed ticket vanishes from the list.
        allTickets = allTickets.filter { $0.status != .completed }
        
        tableView.reloadData()
    }
    
    // MARK: - Setup
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Actions (NEW)
    
    @IBAction func viewFeedbackTapped(_ sender: UIButton) {
        // 1. Get the current logged-in technician's unique UID from Firebase Auth
        guard let currentUID = Auth.auth().currentUser?.uid else {
            print("Error: No technician is logged in")
            return
        }
        
        // 2. Reference the "FeedbackStats" storyboard
        let storyboard = UIStoryboard(name: "FeedbackStats", bundle: nil)
        
        // 3. Instantiate the FeedbackStats controller using its Storyboard ID
        if let statsVC = storyboard.instantiateViewController(withIdentifier: "FeedbackStatsVC") as? FeedbackStats {
            
            // 4. THE CRITICAL FIX: Pass the logged-in ID to the stats page.
            // This replaces "No ID provided" with the actual ID (e.g., "Vz9kt...")
            statsVC.techID = currentUID
            statsVC.techName = "My Performance"
            
            // 5. Navigate to the performance page
            self.navigationController?.pushViewController(statsVC, animated: true)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Directing to the DetailedRequestViewController for active tickets
        if segue.identifier == "showTicketDetail",
           let destinationVC = segue.destination as? DetailedRequestViewController,
           let ticket = sender as? Ticket {
            destinationVC.selectedTicket = ticket
        }
    }
}

// MARK: - TableView Data Source
extension TechnicianDashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTickets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
            return UITableViewCell()
        }
        
        let ticket = allTickets[indexPath.row]
        cell.configure(with: ticket)
        
        // Handle the "View Request in Detail" button tap
        cell.onButtonTapped = { [weak self] in
            self?.performSegue(withIdentifier: "showTicketDetail", sender: ticket)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TechnicianDashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        // Prevents the cell background from changing color when tapped
        return false
    }
}
