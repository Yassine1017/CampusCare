//
//  RequestTableViewCell.swift
//  CampusCare_S3_G5
//
//  Created by ESKY on 20/12/2025.
//

import UIKit

enum RequestAction {
    case edit
    case view
}

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    // 🔑 THIS is how the cell talks to the ViewController
    var actionHandler: ((RequestAction) -> Void)?

    // 🔑 NEW (minimal but important)
    private var actionType: RequestAction = .view

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        contentView.isUserInteractionEnabled = true
        actionButton.isUserInteractionEnabled = true

        idLabel.isUserInteractionEnabled = false
        issueLabel.isUserInteractionEnabled = false
        statusLabel.isUserInteractionEnabled = false
        
        idLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        actionButton.titleLabel?.numberOfLines = 1
        actionButton.titleLabel?.lineBreakMode = .byTruncatingTail

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        actionHandler = nil
    }

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionHandler?(actionType)
    }

    func configure(with request: Ticket) {
        idLabel.text = "#\(request.id)"
        issueLabel.text = request.issue
        statusLabel.text = request.status.rawValue

        // ⭐ SINGLE SOURCE OF TRUTH
        if request.status == .new {
            actionType = .edit
            actionButton.setTitle("Edit", for: .normal)
        } else {
            actionType = .view
            actionButton.setTitle("View", for: .normal)
        }

        actionButton.setTitleColor(.systemBlue, for: .normal)
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 6
    }
}
