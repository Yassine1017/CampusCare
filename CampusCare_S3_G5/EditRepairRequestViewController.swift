//
//  EditRepairRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by ESKY on 20/12/2025.
//

import UIKit
import FirebaseFirestore

class EditRepairRequestViewController: UIViewController,
                                       UIPickerViewDelegate,
                                       UIPickerViewDataSource {


    var request: Ticket!

    @IBOutlet weak var issueTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    

    private let categories = [
        "Electrical",
        "Infrastructure",
        "Network",
        "Plumbing",
        "Environmental"
    ]

    private let pickerView = UIPickerView()


    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
        setupCategoryPicker()
        addDoneToolbar()
    }
    
    //Picker Logic
    
    private func setupCategoryPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        categoryTextField.placeholder = "Select Category"
    }
    
    private func addDoneToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )

        toolbar.setItems([flexSpace, doneButton], animated: false)
        categoryTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneTapped() {
        categoryTextField.resignFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        categoryTextField.text = categories[row]
    }


    private func populateFields() {
        guard let Ticket = request else { return }

        issueTextField.text = Ticket.issue
        locationTextField.text = Ticket.location
        categoryTextField.text = Ticket.category
        
        if let index = categories.firstIndex(of: Ticket.description) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }

    }

    // Update Button Logic
    @IBAction func saveChangesTapped(_ sender: UIButton) {

        guard
            let issue = issueTextField.text, !issue.isEmpty,
            let location = locationTextField.text, !location.isEmpty,
            let category = categoryTextField.text, !category.isEmpty
        else {
            showAlert(title: "Missing Info", message: "Please fill all fields.")
            return
        }

        let docRef = db.collection("requests").document(request.id)

        docRef.updateData([
            "issue": issue,
            "location": location,
            "description": category
        ]) { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // Alert helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // Delete Button Logic
    @IBAction func deleteRequestTapped(_ sender: UIButton) {
        showDeleteConfirmation()
    }
    
    private func showDeleteConfirmation() {
        let alert = UIAlertController(
            title: "Delete Request",
            message: "Are you sure you want to delete this request? This action cannot be undone.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteRequest()
        })

        present(alert, animated: true)
    }
    
    private func deleteRequest() {
        let docRef = db.collection("requests").document(request.id)

        docRef.delete { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }



    
}

