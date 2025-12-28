//
//  TechnicianDashboardViewController.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-17 on 21/12/2025.
//

import UIKit

class TechnicianDashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allTickets: [Ticket] = [] // Holds every ticket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
        }
    
    func setupTableView() {
            tableView.dataSource = self
            tableView.delegate = self
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
                
                cell.onButtonTapped = { [weak self] in
                    self?.performSegue(withIdentifier: "showTicketDetail", sender: ticket)
                }
                return cell
            }
    }

    // MARK: - UITableViewDelegate
    extension TechnicianDashboardViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            return false
        }
}
