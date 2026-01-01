//
//  TicketCell.swift
//  CampusCare_S3_G5
//
//  Created by BP-19-114-02 on 24/12/2025.
//


import UIKit

class TicketCell: UITableViewCell {

    // MARK: - Outlets
    // Connect these to your Storyboard elements
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var requestIDLabel: UILabel!
    @IBOutlet weak var requestTitleLabel: UILabel!
    @IBOutlet weak var requestDateStartLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    // Callback closure for when the button is tapped
    var onButtonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }

    private func setupCardStyle() {
        // 1. Make the background transparent so the gaps show
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        // 2. Style the white card container
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = false // Important for shadow
        
        // Shadow styling to match the image
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
    }

    func configure(with ticket: Ticket) {
        requestIDLabel.text = "ID: #\(ticket.id)"
        requestIDLabel.textColor = .systemBlue
        
        requestTitleLabel.text = ticket.title
        requestTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        requestDateStartLabel.text = ticket.formattedDate
        
    }
    
    @IBAction func detailButtonTapped(_ sender: Any) {
        onButtonTapped?()
    }
}

