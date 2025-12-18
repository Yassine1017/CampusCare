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

        setupStatusPicker()
        setupNavigationBar()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            RequestsHeaderView.self,
            forHeaderFooterViewReuseIdentifier: RequestsHeaderView.identifier
        )
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
        return 5  // 1 header row + 5 data rows
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RequestCell",
            for: indexPath
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: RequestsHeaderView.identifier
        )
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





    


