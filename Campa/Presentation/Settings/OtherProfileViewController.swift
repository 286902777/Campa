import SnapKit
import UIKit

final class OtherProfileViewController: BaseViewController {
    private enum Constants {
        static let backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.86, alpha: 1.0)
        static let purpleColor = UIColor(red: 0.69, green: 0.59, blue: 0.96, alpha: 1.0)
        static let darkTextColor = UIColor(red: 0.28, green: 0.02, blue: 0.01, alpha: 1.0)
        static let mutedTextColor = UIColor(red: 0.42, green: 0.36, blue: 0.32, alpha: 1.0)
    }

    private let userId: UUID
    private let viewModel: ProfileViewModel
    private let userRepository: UserRepository
    private let postRepository: PostRepository

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerImageView = UIImageView()
    private let profilePanelView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let schoolLabel = UILabel()
    private let actionStackView = UIStackView()
    private let chatButton = UIButton(type: .custom)
    private let followButton = UIButton(type: .custom)
    private let locationIconView = UIImageView()
    private let locationLabel = UILabel()
    private let statsStackView = UIStackView()
    private let postCardView = UIView()
    private let postAvatarImageView = UIImageView()
    private let postNameLabel = UILabel()
    private let postMetaLabel = UILabel()
    private let postBodyLabel = UILabel()
    private let postHeroImageView = UIImageView()
    private let thumbnailStackView = UIStackView()
    private let emptyView = EmptyView()
    private var postCardBottomConstraint: Constraint?
    private var emptyBottomConstraint: Constraint?
    private var thumbnailBottomConstraint: Constraint?
    private var heroBottomConstraint: Constraint?

    init(
        userId: UUID,
        viewModel: ProfileViewModel = ProfileViewModel(),
        userRepository: UserRepository = UserRepository(),
        postRepository: PostRepository = PostRepository()
    ) {
        self.userId = userId
        self.viewModel = viewModel
        self.userRepository = userRepository
        self.postRepository = postRepository
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureHeader()
        configureProfilePanel()
        configurePostCard()
        configureLayout()
        loadUserProfile()
    }

    private func configure() {
        view.backgroundColor = Constants.backgroundColor
        changeNavbar(.back)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
    }

    private func configureHeader() {
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
    }

    private func configureProfilePanel() {
        profilePanelView.backgroundColor = Constants.backgroundColor
        profilePanelView.layer.cornerRadius = 34
        profilePanelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        avatarImageView.image = UIImage(named: "user_icon")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 46
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .white

        nameLabel.text = viewModel.name
        nameLabel.font = AppFont.bold(size: 26)
        nameLabel.textColor = Constants.darkTextColor

        schoolLabel.text = viewModel.school
        schoolLabel.font = AppFont.semibold(size: 20)
        schoolLabel.textColor = Constants.mutedTextColor

        configureActionButton(chatButton, title: "Chat", image: UIImage(named: "chat") ?? UIImage(systemName: "message.fill"), tintColor: UIColor(red: 0.08, green: 0.80, blue: 0.34, alpha: 1.0))
        chatButton.addTarget(self, action: #selector(handleChatTapped), for: .touchUpInside)
        configureActionButton(followButton, title: "Follow", image: UIImage(named: "arrow"), tintColor: Constants.darkTextColor)
        followButton.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)

        actionStackView.axis = .horizontal
        actionStackView.alignment = .fill
        actionStackView.distribution = .fillEqually
        actionStackView.spacing = 28

        locationIconView.image = UIImage(named: "location")
        locationIconView.contentMode = .scaleAspectFit
        locationIconView.tintColor = Constants.mutedTextColor

        locationLabel.text = viewModel.location
        locationLabel.font = AppFont.medium(size: 14)
        locationLabel.textColor = Constants.mutedTextColor

        statsStackView.axis = .horizontal
        statsStackView.alignment = .center
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 24
        [
            makeStatView(count: viewModel.followingCount, title: viewModel.followingTitle),
            makeStatView(count: viewModel.followersCount, title: viewModel.followersTitle),
            makeStatView(count: viewModel.postsCount, title: viewModel.postsTitle)
        ].forEach(statsStackView.addArrangedSubview)
    }

    private func configureActionButton(_ button: UIButton, title: String, image: UIImage?, tintColor: UIColor) {
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.tintColor = tintColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(Constants.darkTextColor, for: .normal)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = AppFont.semibold(size: 14)
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
    }

    private func configurePostCard() {
        postCardView.backgroundColor = Constants.purpleColor
        postCardView.layer.cornerRadius = 24
        postCardView.clipsToBounds = true

        postAvatarImageView.image = UIImage(named: "user_icon")
        postAvatarImageView.backgroundColor = .white
        postAvatarImageView.contentMode = .scaleAspectFill
        postAvatarImageView.layer.cornerRadius = 27
        postAvatarImageView.layer.borderColor = UIColor.white.cgColor
        postAvatarImageView.layer.borderWidth = 2
        postAvatarImageView.clipsToBounds = true

        postNameLabel.font = AppFont.semibold(size: 20)
        postNameLabel.textColor = .white

        postMetaLabel.font = AppFont.medium(size: 12)
        postMetaLabel.textColor = UIColor.white.withAlphaComponent(0.82)

        postBodyLabel.font = AppFont.medium(size: 14)
        postBodyLabel.textColor = .white
        postBodyLabel.numberOfLines = 0

        postHeroImageView.contentMode = .scaleAspectFill
        postHeroImageView.clipsToBounds = true
        postHeroImageView.layer.cornerRadius = 8

        thumbnailStackView.axis = .horizontal
        thumbnailStackView.distribution = .fillEqually
        thumbnailStackView.spacing = 4
    }

    private func configureLayout() {
        [headerImageView, profilePanelView, avatarImageView, scrollView].forEach(view.addSubview)
        [statsStackView, nameLabel, schoolLabel, actionStackView, locationIconView, locationLabel].forEach(profilePanelView.addSubview)
        [chatButton, followButton].forEach(actionStackView.addArrangedSubview)
        scrollView.addSubview(contentView)
        contentView.addSubview(postCardView)
        contentView.addSubview(emptyView)
        [postAvatarImageView, postNameLabel, postMetaLabel, postBodyLabel, postHeroImageView, thumbnailStackView].forEach(postCardView.addSubview)
        view.bringSubviewToFront(navBar)

        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.36)
        }
        profilePanelView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(-42)
            make.leading.trailing.bottom.equalToSuperview()
        }
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(62)
            make.centerY.equalTo(profilePanelView.snp.top).offset(-16)
            make.size.equalTo(92)
        }
        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(profilePanelView.snp.top).offset(16)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(24)
            make.trailing.equalTo(profilePanelView.snp.trailing).inset(26)
            make.height.equalTo(54)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.equalTo(profilePanelView.snp.leading).offset(25)
            make.trailing.greaterThanOrEqualTo(statsStackView.snp.leading).inset(25)
        }
        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        actionStackView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(47)
            make.height.equalTo(36)
        }
        locationIconView.snp.makeConstraints { make in
            make.leading.equalTo(schoolLabel.snp.leading)
            make.top.equalTo(actionStackView.snp.bottom).offset(14)
            make.size.equalTo(18)
        }
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIconView.snp.trailing).offset(6)
            make.centerY.equalTo(locationIconView.snp.centerY)
            make.trailing.lessThanOrEqualTo(profilePanelView.snp.trailing).inset(26)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(26)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        postCardView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            postCardBottomConstraint = make.bottom.equalToSuperview().inset(108).constraint
        }
        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(260)
            emptyBottomConstraint = make.bottom.equalToSuperview().inset(108).constraint
        }
        emptyBottomConstraint?.deactivate()
        postAvatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(22)
            make.size.equalTo(54)
        }
        postNameLabel.snp.makeConstraints { make in
            make.top.equalTo(postAvatarImageView.snp.top).offset(2)
            make.leading.equalTo(postAvatarImageView.snp.trailing).offset(14)
            make.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        postMetaLabel.snp.makeConstraints { make in
            make.top.equalTo(postNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(postNameLabel.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        postBodyLabel.snp.makeConstraints { make in
            make.top.equalTo(postAvatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        postHeroImageView.snp.makeConstraints { make in
            make.top.equalTo(postBodyLabel.snp.bottom).offset(18)
            make.leading.trailing.equalTo(postBodyLabel)
            make.height.equalTo(postHeroImageView.snp.width).multipliedBy(0.56)
        }
        thumbnailStackView.snp.makeConstraints { make in
            make.top.equalTo(postHeroImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(postHeroImageView)
            make.height.equalTo(postHeroImageView.snp.height).multipliedBy(0.32)
            thumbnailBottomConstraint = make.bottom.equalToSuperview().inset(22).constraint
        }
        postHeroImageView.snp.makeConstraints { make in
            heroBottomConstraint = make.bottom.equalToSuperview().inset(22).constraint
        }
        heroBottomConstraint?.deactivate()
        emptyView.isHidden = true
    }

    private func loadUserProfile() {
        guard case .success(let user) = userRepository.fetchUser(id: userId) else {
            showEmptyPost()
            return
        }

        apply(user: user)
        loadFirstPost(for: user)
    }

    private func apply(user: User) {
        nameLabel.text = user.nickname
        schoolLabel.text = user.school ?? viewModel.school
        locationLabel.text = user.location ?? viewModel.location
        postNameLabel.text = user.nickname

        guard let avatarLocalPath = avatarPath(from: user.avatarLocalPath),
              let avatarImage = UIImage(contentsOfFile: avatarLocalPath) else {
            headerImageView.image = UIImage(named: "user_icon")
            avatarImageView.image = UIImage(named: "user_icon")
            postAvatarImageView.image = UIImage(named: "user_icon")
            return
        }

        headerImageView.image = avatarImage
        avatarImageView.image = avatarImage
        postAvatarImageView.image = avatarImage
    }

    private func loadFirstPost(for user: User) {
        guard case .success(let posts) = postRepository.fetchPosts(for: user),
              let post = posts.first else {
            showEmptyPost()
            return
        }

        showPostCard()
        configurePost(post, user: user)
    }

    private func configurePost(_ post: Post, user: User) {
        postNameLabel.text = user.nickname
        postMetaLabel.text = "\(user.school ?? post.addressText ?? viewModel.postSchool)  •  \(makeRelativeTime(from: post.createdAt))"
        postBodyLabel.text = post.content

        let images = makePostImages(for: post)
        postHeroImageView.image = images.first ?? UIImage(named: "photo")
        thumbnailStackView.arrangedSubviews.forEach { view in
            thumbnailStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        images.dropFirst().forEach { image in
            thumbnailStackView.addArrangedSubview(makeThumbnailImageView(image: image))
        }
        let shouldHideThumbnails = images.count <= 1
        thumbnailStackView.isHidden = shouldHideThumbnails
        if shouldHideThumbnails {
            thumbnailBottomConstraint?.deactivate()
            heroBottomConstraint?.activate()
        } else {
            heroBottomConstraint?.deactivate()
            thumbnailBottomConstraint?.activate()
        }
    }

    private func showEmptyPost() {
        postCardView.isHidden = true
        emptyView.isHidden = false
        postCardBottomConstraint?.deactivate()
        emptyBottomConstraint?.activate()
    }

    private func showPostCard() {
        postCardView.isHidden = false
        emptyView.isHidden = true
        emptyBottomConstraint?.deactivate()
        postCardBottomConstraint?.activate()
    }

    private func makePostImages(for post: Post) -> [UIImage] {
        guard case .success(let postImages) = postRepository.fetchImages(for: post) else {
            return []
        }

        return postImages.compactMap { image in
            postImageURL(for: image.localPath).flatMap { UIImage(contentsOfFile: $0.path) }
        }
    }

    private func postImageURL(for storedPath: String) -> URL? {
        let value = storedPath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return nil }
        if value.hasPrefix("/") { return URL(fileURLWithPath: value) }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("PostImages", isDirectory: true)
            .appendingPathComponent(value)
    }

    private func avatarPath(from storedPath: String?) -> String? {
        let value = storedPath?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !value.isEmpty else { return nil }
        if value.hasPrefix("/") { return value }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Avatars", isDirectory: true)
            .appendingPathComponent(value)
            .path
    }

    private func makeRelativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func makeStatView(count: String, title: String) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2

        let countLabel = UILabel()
        countLabel.text = count
        countLabel.font = AppFont.semibold(size: 25)
        countLabel.textColor = Constants.darkTextColor
        countLabel.textAlignment = .center

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = AppFont.medium(size: 12)
        titleLabel.textColor = Constants.darkTextColor
        titleLabel.textAlignment = .center

        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }

    private func makeThumbnailImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }

    @objc private func handleChatTapped() {
        let viewController = MessagesViewController(receiverUserId: userId)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func handleFollowTapped() {
        guard let currentUser = loadCurrentUser(),
              case .success(let targetUser) = userRepository.fetchUser(id: userId) else {
            AppToast.show(message: NSLocalizedString("User not found.", comment: "Missing user toast"), in: view)
            return
        }

        guard currentUser.id != targetUser.id else {
            AppToast.show(message: NSLocalizedString("You cannot follow yourself.", comment: "Follow self toast"), in: view)
            return
        }

        switch userRepository.addRelation(from: currentUser, to: targetUser, type: .follow) {
        case .success:
            AppToast.show(message: NSLocalizedString("Followed successfully.", comment: "Follow success toast"), in: view)
        case .failure(.duplicateRelation):
            AppToast.show(message: NSLocalizedString("Already followed.", comment: "Already followed toast"), in: view)
        case .failure:
            AppToast.show(message: NSLocalizedString("Failed to follow.", comment: "Follow failure toast"), in: view)
        }
    }

    private func loadCurrentUser() -> User? {
        if let userIdString = UserDefaults.standard.string(forKey: CurrentUserIdKey),
           let userId = UUID(uuidString: userIdString),
           case .success(let user) = userRepository.fetchUser(id: userId) {
            return user
        }

        guard case .success(let user) = userRepository.fetchCurrentUser() else {
            return nil
        }
        return user
    }
}
