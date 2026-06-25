import UIKit

final class SettingsViewController: BaseViewController {
    fileprivate enum Constants {
        static let horizontalInset: CGFloat = 22
        static let rowHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 36
    }

    private let viewModel: SettingsViewModel
    private let rowsStackView = UIStackView()
    private let deleteAccountButton = UIButton(type: .system)
    private let logOutButton = UIButton(type: .system)

    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureRows()
        configureButtons()
        configureLayout()
    }

    private func configureNavigation() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.93, blue: 0.87, alpha: 1.0)
        changeNavbar(.back)
    }

    private func configureRows() {
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false
        rowsStackView.axis = .vertical
        rowsStackView.spacing = 0

        viewModel.rows
            .map(SettingsPlainRowView.init(row:))
            .forEach(rowsStackView.addArrangedSubview)

        view.addSubview(rowsStackView)
    }

    private func configureButtons() {
        configureActionButton(
            deleteAccountButton,
            title: viewModel.deleteAccountTitle,
            backgroundColor: UIColor(red: 0.72, green: 0.62, blue: 0.97, alpha: 1.0)
        )
        configureActionButton(
            logOutButton,
            title: viewModel.logOutTitle,
            backgroundColor: UIColor(red: 0.86, green: 0.90, blue: 0.12, alpha: 1.0)
        )

        view.addSubview(deleteAccountButton)
        view.addSubview(logOutButton)
    }

    private func configureActionButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.28, green: 0.02, blue: 0.02, alpha: 1.0), for: .normal)
        button.titleLabel?.font = AppFont.medium(size: 13)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = Constants.buttonHeight / 2
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            rowsStackView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 12),
            rowsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            rowsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),

            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            logOutButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 14),
            logOutButton.leadingAnchor.constraint(equalTo: deleteAccountButton.leadingAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: deleteAccountButton.trailingAnchor),
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28),
            logOutButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}

private final class SettingsPlainRowView: UIControl {
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()

    init(row: SettingsRow) {
        super.init(frame: .zero)

        configure(row: row)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func configure(row: SettingsRow) {
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = row.title
        titleLabel.font = AppFont.semibold(size: 11)
        titleLabel.textColor = UIColor(red: 0.28, green: 0.02, blue: 0.02, alpha: 1.0)

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.right.circle")
        arrowImageView.tintColor = UIColor(red: 0.28, green: 0.02, blue: 0.02, alpha: 1.0)
        arrowImageView.contentMode = .scaleAspectFit

        addSubview(titleLabel)
        addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: SettingsViewController.Constants.rowHeight),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -12),

            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 18),
            arrowImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
