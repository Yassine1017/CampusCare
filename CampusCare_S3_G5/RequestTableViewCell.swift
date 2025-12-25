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

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        // 🔑 CRITICAL
        contentView.isUserInteractionEnabled = true

        // 🔑 CRITICAL
        actionButton.isUserInteractionEnabled = true

        // Prevent other views stealing touches
        idLabel.isUserInteractionEnabled = false
        issueLabel.isUserInteractionEnabled = false
        statusLabel.isUserInteractionEnabled = false
        
        idLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 90).isActive = true

    }

    

    override func prepareForReuse() {
        super.prepareForReuse()
        actionHandler = nil
    }

   
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        if title == "Edit" {
            actionHandler?(.edit)
        } else {
            actionHandler?(.view)
        }
    }

    func configure(with request: Ticket) {
        idLabel.text = "#\(request.id)"
        issueLabel.text = request.issue
        statusLabel.text = request.status.rawValue

        let title = request.status == .new ? "Edit" : "View"
        actionButton.setTitle(title, for: .normal)
        actionButton.setTitleColor(.systemBlue, for: .normal)
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 6
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        print("Hit view:", view ?? "nil")
        return view
    }
}
