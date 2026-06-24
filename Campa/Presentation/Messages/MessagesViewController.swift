import UIKit

final class MessagesViewController: BaseViewController {
    fileprivate enum Constants {
        static let horizontalInset: CGFloat = 22
        static let inputHeight: CGFloat = 48
        static let estimatedRowHeight: CGFloat = 115
        static let rowSpacing: CGFloat = 18
    }

    private let viewModel: MessagesViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let inputContainerView = UIView()
    private let inputLabel = UILabel()
    private let sendButton = UIButton(type: .custom)

    init(viewModel: MessagesViewModel = MessagesViewModel()) {
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
        configureInputBar()
        configureLayout()
    }

    private func configureView() {
        self.changeNavbar(.all)
        self.setTitleAndRight(title: "name", right: "more", rightSize: CGSize(width: 36, height: 36))
    }

    override func rightAction() {
        print("rightAction")
    }
    
    private func configureMessages() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.dataSource = self
        tableView.register(MessageBubbleTableViewCell.self, forCellReuseIdentifier: MessageBubbleTableViewCell.reuseIdentifier)

        view.addSubview(tableView)
    }

    private func configureInputBar() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.backgroundColor = .white
        inputContainerView.layer.cornerRadius = Constants.inputHeight / 2
        inputContainerView.layer.shadowColor = UIColor.black.cgColor
        inputContainerView.layer.shadowOpacity = 0.06
        inputContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        inputContainerView.layer.shadowRadius = 12

        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.text = viewModel.inputPlaceholder
        inputLabel.font = AppFont.medium(size: 12)
        inputLabel.textColor = UIColor(red: 0.62, green: 0.56, blue: 0.52, alpha: 1.0)

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = UIColor(red: 0.29, green: 0.02, blue: 0.01, alpha: 1.0)
        sendButton.layer.cornerRadius = 18
        sendButton.setImage(UIImage(named: "add_pupor"), for: .normal)
        sendButton.accessibilityIdentifier = "messagesSendButton"

        inputContainerView.addSubview(inputLabel)
        inputContainerView.addSubview(sendButton)
        view.addSubview(inputContainerView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -18),

            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -86),
            inputContainerView.heightAnchor.constraint(equalToConstant: Constants.inputHeight),

            inputLabel.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 18),
            inputLabel.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),

            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36),

            inputLabel.trailingAnchor.constraint(lessThanOrEqualTo: sendButton.leadingAnchor, constant: -12)
        ])
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageBubbleTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MessageBubbleTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(message: viewModel.messages[indexPath.row])
        return cell
    }
}

private final class MessageBubbleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MessageBubbleTableViewCell"

    private let bubbleView = MessageBubbleView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(message: MessageBubble) {
        bubbleView.configure(message: message)
    }

    private func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MessagesViewController.Constants.horizontalInset),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MessagesViewController.Constants.horizontalInset),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MessagesViewController.Constants.rowSpacing)
        ])
    }
}

private final class MessageBubbleView: UIView {
    private let avatarImageView = UIImageView()
    private let bubbleLabel = UILabel()
    private let bubbleContainerView = UIView()

    init(message: MessageBubble? = nil) {
        super.init(frame: .zero)

        configureView()
        configureLayout()

        if let message {
            configure(message: message)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(message: MessageBubble) {
        bubbleLabel.text = message.text
        bubbleContainerView.backgroundColor = message.isOutgoing
            ? UIColor(red: 0.87, green: 0.92, blue: 0.09, alpha: 1.0)
            : UIColor(red: 0.70, green: 0.60, blue: 0.96, alpha: 1.0)
        bubbleLabel.textColor = message.isOutgoing
            ? UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0)
            : .white
        outgoingConstraints.forEach { $0.isActive = message.isOutgoing }
        incomingConstraints.forEach { $0.isActive = !message.isOutgoing }
    }

    private var incomingConstraints: [NSLayoutConstraint] = []
    private var outgoingConstraints: [NSLayoutConstraint] = []

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "photo")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true

        bubbleContainerView.translatesAutoresizingMaskIntoConstraints = false
        bubbleContainerView.layer.cornerRadius = 16

        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.font = AppFont.medium(size: 12)
        bubbleLabel.numberOfLines = 0

        addSubview(avatarImageView)
        addSubview(bubbleContainerView)
        bubbleContainerView.addSubview(bubbleLabel)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 97),

            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),

            bubbleContainerView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 7),
            bubbleContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bubbleContainerView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.72),

            bubbleLabel.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor, constant: 12),
            bubbleLabel.leadingAnchor.constraint(equalTo: bubbleContainerView.leadingAnchor, constant: 14),
            bubbleLabel.trailingAnchor.constraint(equalTo: bubbleContainerView.trailingAnchor, constant: -14),
            bubbleLabel.bottomAnchor.constraint(equalTo: bubbleContainerView.bottomAnchor, constant: -12)
        ])

        incomingConstraints = [
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleContainerView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ]
        outgoingConstraints = [
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bubbleContainerView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor)
        ]
    }
}
