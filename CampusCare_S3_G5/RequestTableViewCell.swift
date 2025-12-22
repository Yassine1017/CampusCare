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

    // 🔑 THIS is how the cell talks to the ViewController
    var actionHandler: (() -> Void)?

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
    }

    

    override func prepareForReuse() {
        super.prepareForReuse()
        actionHandler = nil
    }

    // 🔥 THIS must be connected to the button
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        print("🔥 BUTTON TAPPED")
        actionHandler?()
    }

    func configure(with request: RepairRequest) {
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
