import UIKit

final class MessageListViewController: BaseViewController {
    fileprivate enum Constants {
        static let horizontalInset: CGFloat = 20
        static let estimatedRowHeight: CGFloat = 75
        static let rowSpacing: CGFloat = 13
        static let cardCornerRadius: CGFloat = 16
    }

    private let viewModel: MessageListViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(viewModel: MessageListViewModel = MessageListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureMessages()
        configureLayout()
    }

    private func configureView() {
        self.changeNavbar(.titleRightBtn)
        self.setTitleAndRight(title: "Message", right: "star", rightSize: CGSize(width: 89, height: 41))
    }

    private func configureMessages() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageListTableViewCell.self, forCellReuseIdentifier: MessageListTableViewCell.reuseIdentifier)

        view.addSubview(tableView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 27),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MessageListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageListTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MessageListTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(item: viewModel.messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let _ = viewModel.messages[indexPath.row]
         let vc = MessagesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

private final class MessageListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MessageListTableViewCell"

    private let cardView = MessageListCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(item: MessageListItem) {
        cardView.configure(item: item)
    }

    private func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MessageListViewController.Constants.horizontalInset),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MessageListViewController.Constants.rowSpacing)
        ])
    }
}

private final class MessageListCardView: UIView {
    private enum Constants {
        static let avatarSize: CGFloat = 39
        static let unreadSize: CGFloat = 14
    }

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let previewLabel = UILabel()
    private let timeLabel = UILabel()

    init(item: MessageListItem? = nil) {
        super.init(frame: .zero)

        configureView()
        configureLayout()

        if let item {
            configure(item: item)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(item: MessageListItem) {
        nameLabel.text = item.name
        previewLabel.text = item.preview
        timeLabel.text = item.time
    }

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.86, green: 0.91, blue: 0.10, alpha: 1.0)
        layer.cornerRadius = MessageListViewController.Constants.cardCornerRadius
        clipsToBounds = true
        accessibilityIdentifier = "messageListCardView"

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "user_icon")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = Constants.avatarSize / 2
        avatarImageView.clipsToBounds = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = AppFont.semibold(size: 12)
        nameLabel.textColor = UIColor(red: 0.18, green: 0.10, blue: 0.08, alpha: 1.0)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        previewLabel.font = AppFont.medium(size: 11)
        previewLabel.textColor = UIColor(red: 0.18, green: 0.10, blue: 0.08, alpha: 1.0)
        previewLabel.numberOfLines = 0
        previewLabel.adjustsFontSizeToFitWidth = true
        previewLabel.minimumScaleFactor = 0.85

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = AppFont.medium(size: 8)
        timeLabel.textColor = UIColor(red: 0.40, green: 0.34, blue: 0.26, alpha: 1.0)
        timeLabel.textAlignment = .right
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(previewLabel)
        addSubview(timeLabel)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize),

            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 17),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

            previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            previewLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            previewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            previewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),

            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])
    }
}
