import UIKit

final class MessagesViewController: UIViewController {
    private enum Constants {
        static let horizontalInset: CGFloat = 22
        static let inputHeight: CGFloat = 48
    }

    private let viewModel: MessagesViewModel
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
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
        configureTitleLabel()
        configureMessages()
        configureInputBar()
        configureLayout()
    }

    private func configureView() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.86, alpha: 1.0)
    }

    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = viewModel.title
        titleLabel.font = AppFont.semibold(size: 21)
        titleLabel.textColor = UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.accessibilityIdentifier = "messagesTitleLabel"
        view.addSubview(titleLabel)
    }

    private func configureMessages() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18

        viewModel.messages.map(MessageBubbleView.init(message:)).forEach(stackView.addArrangedSubview)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -18),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Constants.horizontalInset),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Constants.horizontalInset),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -Constants.horizontalInset * 2),

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

private final class MessageBubbleView: UIView {
    private let avatarImageView = UIImageView()
    private let bubbleLabel = UILabel()
    private let bubbleContainerView = UIView()

    init(message: MessageBubble) {
        super.init(frame: .zero)

        configure(message: message)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func configure(message: MessageBubble) {
        translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "photo")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true

        bubbleContainerView.translatesAutoresizingMaskIntoConstraints = false
        bubbleContainerView.backgroundColor = message.isOutgoing
            ? UIColor(red: 0.87, green: 0.92, blue: 0.09, alpha: 1.0)
            : UIColor(red: 0.70, green: 0.60, blue: 0.96, alpha: 1.0)
        bubbleContainerView.layer.cornerRadius = 16

        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.text = message.text
        bubbleLabel.font = AppFont.medium(size: 12)
        bubbleLabel.textColor = message.isOutgoing
            ? UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0)
            : .white
        bubbleLabel.numberOfLines = 0

        addSubview(avatarImageView)
        addSubview(bubbleContainerView)
        bubbleContainerView.addSubview(bubbleLabel)

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

        if message.isOutgoing {
            NSLayoutConstraint.activate([
                avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                bubbleContainerView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bubbleContainerView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
            ])
        }
    }
}
