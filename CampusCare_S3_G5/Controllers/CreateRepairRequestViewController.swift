//
//  CreateRepairRequestViewController.swift
//  CampusCare_S3_G5
//
//  Created by Mawlid Benmansour on 17/12/2025.
//

import UIKit

class CreateNewRepairRequestViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!

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
        categoryTextField.resignFirstResponder()
    }
}




