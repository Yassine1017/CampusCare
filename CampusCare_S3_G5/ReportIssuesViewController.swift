//
//  ReportIssuesViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 18/12/2025.
//

import UIKit

class ReportIssuesViewController: UIViewController {

    // MARK: - UI Elements
    // Since you are connecting manually, we define them here.
    // They will be initialized when the view loads.
    
    private var splashImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var getStartedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        identifyElements() // Map your UI elements
        setupConstraints() // Fix the layout
    }

    private func identifyElements() {
        // We will find the elements you added in Storyboard by their position or Tag.
        // For a cleaner approach, you can assign 'Tags' to each element in Storyboard.
        
        // Example: Finding the button among subviews
        for subview in view.subviews {
            if let button = subview as? UIButton {
                self.getStartedButton = button
            } else if let imageView = subview as? UIImageView {
                self.splashImageView = imageView
            } else if let label = subview as? UILabel {
                // Logic to distinguish labels based on text or order
                if label.text == "Report Issues" { self.titleLabel = label }
                else if label.text == "On Campus easily!" { self.subTitleLabel = label }
                else { self.descriptionLabel = label }
            }
        }
        
        // Add action to the button programmatically
        getStartedButton?.addTarget(self, action: #selector(didTapGetStarted), for: .touchUpInside)
    }

    private func setupConstraints() {
        // Ensure all elements use Auto Layout
        let elements: [UIView?] = [splashImageView, titleLabel, subTitleLabel, descriptionLabel, getStartedButton]
        elements.compactMap { $0 }.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        // Activate constraints to fix the layout on all screens
        NSLayoutConstraint.activate([
            // Splash Image: Top of safe area
            splashImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            splashImageView.heightAnchor.constraint(equalTo: splashImageView.widthAnchor),

            // Title: Below Image
            titleLabel.topAnchor.constraint(equalTo: splashImageView.bottomAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Subtitle: Below Title
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Description: Below Subtitle
            descriptionLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            // Button: Bottom of screen
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    
    @objc private func didTapGetStarted() {
        print("Navigation to Sign In page...")
        // Add your segue or navigation code here
    }
}
