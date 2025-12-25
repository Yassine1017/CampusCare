//
//  RepairRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by Mawlid Benmansour on 16/12/2025.
//

import UIKit
import FirebaseFirestore

class RepairRequestViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Firebase
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // MARK: - Data
    private var tickets: [Ticket] = []
    private var filteredTickets: [Ticket] = []
    private var selectedTicket: Ticket?

    // MARK: - Picker
    private let statusPicker = UIPickerView()
    private let statusOptions = [
        "All",
        "new",
        "inProgress",
        "resolved",
        "closed"
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        setupStatusPicker()
        setupNavigationBar()
        setupTableHeader()

        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.contentInsetAdjustmentBehavior = .never

        listenForTickets()
    }

    deinit {
        listener?.remove()
    }

    // MARK: - Firestore Listener (NEW TICKETS DB)
    private func listenForTickets() {
        listener = db.collection("tickets")
            .order(by: "dateCommenced", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Firestore error:", error)
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.tickets = documents.compactMap {
                    try? $0.data(as: Ticket.self)
                }

                self.applyFilters()
            }
    }

    // MARK: - Filtering Logic
    private func applyFilters() {

        let statusFilter = statusTextField.text ?? "All"
        let searchText = searchBar.text ?? ""

        filteredTickets = tickets.filter { ticket in

            let matchesStatus: Bool = {
                if statusFilter == "All" { return true }
                return ticket.status.rawValue == statusFilter
            }()

            let matchesSearch: Bool = {
                if searchText.isEmpty { return true }
                return ticket.id.localizedCaseInsensitiveContains(searchText)
            }()

            return matchesStatus && matchesSearch
        }

        tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ticket = selectedTicket else { return }

        if segue.identifier == "showEditRequest" {
            let dest = segue.destination as? UINavigationController
            let vc = dest?.topViewController as? EditRepairRequestViewController
                ?? segue.destination as? EditRepairRequestViewController
            vc?.request = ticket
        }

        if segue.identifier == "showTrackRequest" {
            let dest = segue.destination as? UINavigationController
            let vc = dest?.topViewController as? TrackRequestViewController
                ?? segue.destination as? TrackRequestViewController
            vc?.request = ticket
        }
    }

    // MARK: - UI Setup
    private func setupTableHeader() {
        let header = RequestsTableHeaderView(
            frame: CGRect(x: 0, y: 0,
                          width: tableView.bounds.width,
                          height: 44)
        )
        tableView.tableHeaderView = header
    }

    private func setupStatusPicker() {
        statusPicker.delegate = self
        statusPicker.dataSource = self

        statusTextField.inputView = statusPicker
        statusTextField.tintColor = .clear

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )

        toolbar.items = [doneButton]
        statusTextField.inputAccessoryView = toolbar

        statusTextField.text = statusOptions.first
    }

    @objc private func doneTapped() {
        statusTextField.resignFirstResponder()
        applyFilters()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UITableView
extension RepairRequestViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        filteredTickets.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RequestCell",
            for: indexPath
        ) as! RequestTableViewCell

        let ticket = filteredTickets[indexPath.row]
        cell.configure(with: ticket)

        cell.actionHandler = { [weak self] action in
            guard let self = self else { return }
            self.selectedTicket = ticket

            switch action {
            case .edit:
                self.performSegue(withIdentifier: "showEditRequest", sender: self)
            case .view:
                self.performSegue(withIdentifier: "showTrackRequest", sender: self)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

// MARK: - UIPickerView
extension RepairRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        statusOptions.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        statusOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        statusTextField.text = statusOptions[row]
    }
}

// MARK: - Search Bar
extension RepairRequestViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        applyFilters()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
