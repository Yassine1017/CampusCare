//
//  RequestTableViewCell.swift
//  CampusCare_S3_G5
//
//  Created by ESKY on 20/12/2025.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = .zero
    }
    
    func configure(with request: RepairRequest) {

        idLabel.text = "#\(request.id)"
        issueLabel.text = request.issue
        statusLabel.text = request.status.rawValue

        actionButton.isHidden = false   // 👈 IMPORTANT

        switch request.status {
        case .new:
            actionButton.setTitle("Edit", for: .normal)
            actionButton.backgroundColor = .systemRed

        case .inProgress, .completed:
            actionButton.setTitle("View", for: .normal)
            actionButton.backgroundColor = .systemBlue
        }
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.isHidden = true
    }


    // Callback to the ViewController
    var actionHandler: (() -> Void)?

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionHandler?()
    }
}


