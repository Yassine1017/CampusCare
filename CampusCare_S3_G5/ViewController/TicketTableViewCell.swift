import UIKit

class TicketTableViewCell: UITableViewCell {

    private let idLabel = UILabel()
    private let statusLabel = UILabel()
    private let descriptionLabel = UILabel()

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

        [idLabel, statusLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        idLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 2

        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            statusLabel.topAnchor.constraint(equalTo: idLabel.topAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with ticket: Ticket) {
        idLabel.text = "Ticket ID: \(ticket.id.prefix(8))"
        descriptionLabel.text = ticket.description
        statusLabel.text = ticket.status.rawValue
        statusLabel.textColor = ticket.status.color
    }
}
