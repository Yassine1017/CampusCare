//
//  RequestTableHeaderView.swift
//  CampusCare_S3_G5
//
//  Created by ESKY on 24/12/2025.
//

import Foundation
import UIKit

final class RequestsTableHeaderView: UIView {

    private let idLabel = UILabel()
    private let issueLabel = UILabel()
    private let statusLabel = UILabel()
    private let actionLabel = UILabel()

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6

        // Labels
        [idLabel, issueLabel, statusLabel, actionLabel].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .semibold)
            $0.textColor = .secondaryLabel
        }

        idLabel.text = "ID"
        issueLabel.text = "Issue"
        statusLabel.text = "Status"
        actionLabel.text = "Action"

        // StackView
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8

        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(issueLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(actionLabel)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            idLabel.widthAnchor.constraint(equalToConstant: 40),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            actionLabel.widthAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}

