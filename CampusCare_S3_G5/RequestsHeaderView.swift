//
//  RequestsHeaderView.swift
//  CampusCare_S3_G5
//
//  Created by Mawlid Benmansour on 16/12/2025.
//

import UIKit

final class RequestsHeaderView: UITableViewHeaderFooterView {

    static let identifier = "RequestsHeaderView"

    private let idLabel = RequestsHeaderView.makeLabel(text: "ID")
    private let issueLabel = RequestsHeaderView.makeLabel(text: "Issue")
    private let statusLabel = RequestsHeaderView.makeLabel(text: "Status")
    private let actionLabel = RequestsHeaderView.makeLabel(text: "Action")

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemGray6

        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(issueLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(actionLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }
}
