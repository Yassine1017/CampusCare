//
//  RepairRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by Mawlid Benmansour on 16/12/2025.
//

import UIKit

class RepairRequestViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var statusTextField: UITextField!
    
    var requests: [RepairRequest] = []

    
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
        
        loadSampleData()
        

        setupStatusPicker()
        setupNavigationBar()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            RequestsHeaderView.self,
            forHeaderFooterViewReuseIdentifier: RequestsHeaderView.identifier
        )
    }
    
    func loadSampleData() {
        requests = [
            RepairRequest(
                id: 1,
                issue: "Leaking Faucet",
                status: .new,
                assignmentDate: nil,
                technicianName: nil,
                category: "Plumbing",
                notes: []
            ),
            RepairRequest(
                id: 2,
                issue: "Broken Light",
                status: .completed,
                assignmentDate: Date(),
                technicianName: "Ahmed Hussain",
                category: "Electrical",
                notes: []
            )
        ]
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
        guard let request = sender as? RepairRequest else { return }

        if segue.identifier == "showEditRequest" {
            let vc = segue.destination as! EditRequestViewController
            vc.request = request
        }

        if segue.identifier == "showTrackRequest" {
            let vc = segue.destination as! TrackRequestViewController
            vc.request = request
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
        return requests.count
    }


    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "RequestCell",
            for: indexPath
        ) as? RequestTableViewCell else {
            fatalError("RequestCell not connected properly")
        }

        let request = requests[indexPath.row]

        cell.idLabel.text = "#\(request.id)"
        cell.issueLabel.text = request.issue
        cell.statusLabel.text = request.status.rawValue

        if request.status == .new {
            cell.actionButton.setTitle("Edit", for: .normal)
        } else {
            cell.actionButton.setTitle("View", for: .normal)
        }

        cell.actionHandler = { [weak self] in
            self?.handleAction(for: request)
        }

        return cell
    }
    
    
    func handleAction(for request: RepairRequest) {
        if request.status == .new {
            performSegue(withIdentifier: "showEditRequest", sender: request)
        } else {
            performSegue(withIdentifier: "showTrackRequest", sender: request)
        }
    }



    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {

        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: RequestsHeaderView.identifier
        ) as? RequestsHeaderView else {
            return nil
        }

        return header
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








    


