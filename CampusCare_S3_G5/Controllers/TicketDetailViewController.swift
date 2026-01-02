import UIKit
import FirebaseFirestore

class TicketDetailViewController: UIViewController {

    var ticket: Ticket!

    private let assignButton = UIButton(type: .system)
    private var technicians: [(id: String, name: String)] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Ticket Details"

        setupUI()
        setupAssignButton()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            makeRow("Issue", ticket.issue),
            makeRow("Location", ticket.location),
            makeRow("Status", ticket.status.rawValue),
            makeRow("Priority", ticket.priority.rawValue),
            makeRow("Category", ticket.category),
            makeRow("Description", ticket.description)
        ])

        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func makeRow(_ title: String, _ value: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title

        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.text = value
        valueLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    private func setupAssignButton() {
        guard ticket.status == .new else { return }

        assignButton.setTitle("Assign Ticket", for: .normal)
        assignButton.backgroundColor = .systemBlue
        assignButton.setTitleColor(.white, for: .normal)
        assignButton.layer.cornerRadius = 8
        assignButton.translatesAutoresizingMaskIntoConstraints = false

        assignButton.addTarget(self, action: #selector(assignTicketTapped), for: .touchUpInside)

        view.addSubview(assignButton)

        NSLayoutConstraint.activate([
            assignButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            assignButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            assignButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            assignButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func assignTicketTapped() {
        fetchTechnicians()
    }
    
    private func fetchTechnicians() {
        Firestore.firestore()
            .collection("users").whereField("role", isEqualTo: "technician")
            .getDocuments { [weak self] snapshot, error in
                guard let self else { return }

                if let error = error {
                    print("Failed to load technicians:", error)
                    return
                }

                self.technicians = snapshot?.documents.compactMap { doc in
                    let data = doc.data()

                    guard
                        let firstName = data["firstName"] as? String,
                        let lastName = data["lastName"] as? String
                    else {
                        return nil
                    }

                    let fullName = "\(firstName) \(lastName)"
                    return (id: doc.documentID, name: fullName)
                } ?? []


                if self.technicians.isEmpty {
                    print("No technicians found")
                    return
                }

                self.showTechnicianPicker()
            }
    }
    private func showTechnicianPicker() {
        let alert = UIAlertController(
            title: "Assign Technician",
            message: "Select a technician",
            preferredStyle: .actionSheet
        )

        for tech in technicians {
            alert.addAction(UIAlertAction(title: tech.name, style: .default) { _ in
                self.assign(ticketTo: tech)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // iPad safety
        if let popover = alert.popoverPresentationController {
            popover.sourceView = assignButton
            popover.sourceRect = assignButton.bounds
        }

        present(alert, animated: true)
    }
    
    private func assign(ticketTo technician: (id: String, name: String)) {
        Firestore.firestore()
            .collection("tickets")
            .document(ticket.id)
            .updateData([
                "assignedTo": technician.id,
                "status": "In Progress"
            ]) { error in
                if let error = error {
                    print("Assignment failed:", error)
                    return
                }

                print("Ticket assigned to \(technician.name)")
                self.navigationController?.popViewController(animated: true)
            }
    }



}



