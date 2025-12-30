import UIKit

class TicketTableViewCell: UITableViewCell {

    private let issueLabel = UILabel()
    private let locationLabel = UILabel()
    private let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        issueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        issueLabel.numberOfLines = 2

        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel

        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        let stack = UIStackView(arrangedSubviews: [
            issueLabel,
            locationLabel,
            statusLabel
        ])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with ticket: Ticket) {
        issueLabel.text = "Issue: \(ticket.issue)"
        locationLabel.text = "Location: \(ticket.location)"
        statusLabel.text = "Status: \(ticket.status.rawValue)"
        statusLabel.textColor = ticket.status.color
    }
}
