//
//  CreateRepairRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by Mawlid Benmansour on 17/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateNewRepairRequestViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var issueTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    private let db = Firestore.firestore()

    
    private let categories = [
        "Electrical",
        "Infrastructure",
        "Network",
        "Plumbing",
        "Environmental"
    ]

    private let pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create New Request"
        view.backgroundColor = .systemBackground

        setupCategoryPicker()
        addDoneToolbar()
    }
    
    @IBAction func submitRequestTapped(_ sender: UIButton) {

        guard
            let issue = issueTextField.text, !issue.isEmpty,
            let location = locationTextField.text, !location.isEmpty,
            let category = categoryTextField.text, !category.isEmpty
        else {
            showAlert(title: "Missing Info", message: "Please fill all fields.")
            return
        }

        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "User not logged in.")
            return
        }

        let counterRef = db.collection("counters").document("requests")
        let requestsRef = db.collection("requests")

        db.runTransaction({ transaction, errorPointer -> Any? in

            let counterSnapshot: DocumentSnapshot
            do {
                counterSnapshot = try transaction.getDocument(counterRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            let current = counterSnapshot.data()?["current"] as? Int ?? 0
            let newId = current + 1

            let request = RepairRequest(
                id: String(newId),
                issue: issue,
                description: category,
                location: location,
                status: .new,
                userId: userId,
                technicianName: nil,
                createdAt: Timestamp(),
                assignmentDate: nil,
                notes: nil
            )

            let newRequestRef = requestsRef.document(String(newId))

            do {
                let encoded = try Firestore.Encoder().encode(request)
                transaction.setData(encoded, forDocument: newRequestRef)
                transaction.updateData(["current": newId], forDocument: counterRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            return nil

        }) { _, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }

    }




    private func setupCategoryPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self

        categoryTextField.inputView = pickerView

        categoryTextField.placeholder = "Select Category"
    }
}

extension CreateNewRepairRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }



}




