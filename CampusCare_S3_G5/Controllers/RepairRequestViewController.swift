//
//  RepairRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by Mawlid Benmansour on 16/12/2025.
//

import UIKit
import FirebaseFirestore

class RepairRequestViewController: UIViewController, UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var searchBar: UISearchBar!

    
    
    private let db = Firestore.firestore()
    
    func fetchRequests() {
        db.collection("requests")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                
                guard let self = self else { return }
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }

                self.requests = documents.compactMap {
                    try? $0.data(as: RepairRequest.self)
                }
                self.filteredRequests = self.requests


                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }

    
   var requests: [RepairRequest] = []
    private var selectedRequest: RepairRequest?
    
    private var filteredRequests: [RepairRequest] = []

    
    


    
    // MARK: - Properties
    let statusPicker = UIPickerView()

    let statusOptions = [
        "All",
        "New",
        "In Progress",
        "Completed"
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRequests()

        
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never

        setupStatusPicker()
        setupNavigationBar()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        
        setupTableHeader()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredRequests = requests
            tableView.reloadData()
            return
        }

        filteredRequests = requests.filter {
            $0.id == searchText
        }

        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


    
    
    private func setupTableHeader() {
        let header = RequestsTableHeaderView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tableView.bounds.width,
                height: 44
            )
        )

        tableView.tableHeaderView = header
    }
    
    
    

    // MARK: - Picker Setup
    func setupStatusPicker() {
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
        
        statusPicker.selectRow(0, inComponent: 0, animated: false)
        statusTextField.text = statusOptions[0]

    }

    @objc func doneTapped() {
        statusTextField.resignFirstResponder()
    }

    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let request = selectedRequest else { return }

        if segue.identifier == "showEditRequest" {
            let dest = segue.destination
            let vc = (dest as? UINavigationController)?.topViewController as? EditRepairRequestViewController
                     ?? dest as? EditRepairRequestViewController
            vc?.request = request
        }

        if segue.identifier == "showTrackRequest" {
            let dest = segue.destination
            let vc = (dest as? UINavigationController)?.topViewController as? TrackRequestViewController
                     ?? dest as? TrackRequestViewController
            vc?.request = request
        }
    }



}

// All functions for picker button
extension RepairRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return statusOptions.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return statusOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        statusTextField.text = statusOptions[row]
    }
}





//All functions for table view


extension RepairRequestViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredRequests.count
    }
   
        func tableView(_ tableView: UITableView,
                       heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44        }

      
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RequestCell",
            for: indexPath
        ) as! RequestTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.contentView.layoutMargins = .zero


        let request = filteredRequests[indexPath.row]

        
        cell.configure(with: request)

        cell.actionHandler = { [weak self] action in
            guard let self = self else { return }

            self.selectedRequest = request

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
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }


    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row != 0 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("Tapped row \(indexPath.row)")
    }
          
}

extension RepairRequestViewController: UITextFieldDelegate {}









    


