import UIKit

class PerformanceDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    // Sample Data
    var allTechnicians: [TechnicianPerformance] = [
        TechnicianPerformance(name: "Ahmed Ali", averageRating: 4.8, totalCompleted: 45, avgResolutionTime: "1.5h", specialty: "AC"),
        TechnicianPerformance(name: "Sara Ahmed", averageRating: 4.2, totalCompleted: 30, avgResolutionTime: "2.1h", specialty: "Plumbing"),
        TechnicianPerformance(name: "John Doe", averageRating: 3.9, totalCompleted: 12, avgResolutionTime: "3.0h", specialty: "Electrical")
    ]
    
    var filteredTechs: [TechnicianPerformance] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Performance Dashboard"
        filteredTechs = allTechnicians
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Search Bar Setup
        searchBar.delegate = self
        searchBar.placeholder = "Filter by name or specialty"
        
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView])
        stackView.axis = .vertical
        stackView.frame = view.bounds
        view.addSubview(stackView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TechCell")
    }

    // MARK: - Search Logic
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTechs = allTechnicians
        } else {
            filteredTechs = allTechnicians.filter { $0.name.contains(searchText) || $0.specialty.contains(searchText) }
        }
        tableView.reloadData()
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTechs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TechCell")
        let tech = filteredTechs[indexPath.row]
        
        cell.textLabel?.text = "\(tech.name) - \(tech.specialty)"
        cell.detailTextLabel?.text = "Rating: ⭐\(tech.averageRating) | Done: \(tech.totalCompleted) | Avg Time: \(tech.avgResolutionTime)"
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
