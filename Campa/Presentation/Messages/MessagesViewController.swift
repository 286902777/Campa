import IQKeyboardManagerSwift
import UIKit

final class MessagesViewController: BaseViewController {
    fileprivate enum Constants {
        static let horizontalInset: CGFloat = 22
        static let inputHeight: CGFloat = 48
        static let inputVerticalInset: CGFloat = 8
        static let maxInputLines: CGFloat = 4
        static let inputBottomInset: CGFloat = 34
        static let keyboardInputSpacing: CGFloat = 12
        static let estimatedRowHeight: CGFloat = 115
        static let rowSpacing: CGFloat = 18
    }

    private let viewModel: MessagesViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let inputContainerView = UIView()
    private let inputTextView = UITextView()
    private let inputPlaceholderLabel = UILabel()
    private let sendButton = UIButton(type: .custom)
    private var inputContainerHeightConstraint: NSLayoutConstraint?
    private var inputContainerBottomConstraint: NSLayoutConstraint?

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
        configureKeyboardHandling()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateInputTextViewHeight()
    }

    private func configureView() {
        self.changeNavbar(.all)
        self.setTitleAndRight(title: "name", right: "more", rightSize: CGSize(width: 36, height: 36))
    }

    override func rightAction() {
        let vc = ReportViewController()
        vc.clickBlock = {
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
        inputContainerView.backgroundColor = UIColor(red: 52/255.0, green: 4/255, blue: 4/255.0, alpha: 1.0)
        inputContainerView.layer.cornerRadius = 8

        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.backgroundColor = .clear
        inputTextView.font = AppFont.medium(size: 14)
        inputTextView.textColor = .white
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextView.showsVerticalScrollIndicator = false
        inputTextView.isScrollEnabled = false
        inputTextView.delegate = self
        inputTextView.iq.enableMode = .disabled

        inputPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        inputPlaceholderLabel.text = "Say something...."
        inputPlaceholderLabel.font = AppFont.medium(size: 12)
        inputPlaceholderLabel.textColor = UIColor(red: 0.62, green: 0.56, blue: 0.52, alpha: 1.0)

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        sendButton.accessibilityIdentifier = "messagesSendButton"

        inputContainerView.addSubview(inputTextView)
        inputTextView.addSubview(inputPlaceholderLabel)
        inputContainerView.addSubview(sendButton)
        view.addSubview(inputContainerView)
        updatePlaceholderVisibility()
    }

    private func configureLayout() {
        inputContainerHeightConstraint = inputContainerView.heightAnchor.constraint(equalToConstant: Constants.inputHeight)
        inputContainerHeightConstraint?.isActive = true
        inputContainerBottomConstraint = inputContainerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -Constants.inputBottomInset
        )
        inputContainerBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -18),

            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),

            inputTextView.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: Constants.inputVerticalInset),
            inputTextView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 18),
            inputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            inputTextView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -Constants.inputVerticalInset),

            inputPlaceholderLabel.topAnchor.constraint(equalTo: inputTextView.topAnchor, constant: 8),
            inputPlaceholderLabel.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor),
            inputPlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: inputTextView.trailingAnchor),

            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func configureKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardFrameChanged(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardFrameChanged(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func updatePlaceholderVisibility() {
        inputPlaceholderLabel.isHidden = !inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func updateInputTextViewHeight() {
        let textWidth = inputTextView.bounds.width
        guard textWidth > 0 else {
            return
        }

        let fittingHeight = inputTextView.sizeThatFits(
            CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        ).height
        let lineHeight = inputTextView.font?.lineHeight ?? AppFont.medium(size: 12).lineHeight
        let maxTextHeight = lineHeight * Constants.maxInputLines
            + inputTextView.textContainerInset.top
            + inputTextView.textContainerInset.bottom
        let textHeight = min(fittingHeight, maxTextHeight)
        let containerHeight = max(Constants.inputHeight, textHeight + Constants.inputVerticalInset * 2)

        inputTextView.isScrollEnabled = fittingHeight > maxTextHeight
        guard abs((inputContainerHeightConstraint?.constant ?? 0) - containerHeight) > 0.5 else {
            return
        }

        inputContainerHeightConstraint?.constant = containerHeight
    }

    @objc private func handleKeyboardFrameChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let keyboardOverlap = max(0, view.bounds.maxY - keyboardFrameInView.minY - view.safeAreaInsets.bottom)
        let bottomInset = keyboardOverlap > 0
            ? keyboardOverlap + Constants.keyboardInputSpacing
            : Constants.inputBottomInset
        inputContainerBottomConstraint?.constant = -bottomInset

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        let curveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        let options = UIView.AnimationOptions(rawValue: curveRawValue << 16)

        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
            self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.messages.count > 0 ? (self.viewModel.messages.count - 1) : 0, section: 0), at: .none, animated: false)
        }
    }
}

extension MessagesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        updateInputTextViewHeight()
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
