import UIKit

final class HomeViewController: BaseViewController {
    fileprivate enum Constants {
        static let horizontalInset: CGFloat = 20
        static let backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.86, alpha: 1.0)
        static let darkTextColor = UIColor(red: 0.28, green: 0.02, blue: 0.02, alpha: 1.0)
        static let mutedTextColor = UIColor(red: 0.45, green: 0.37, blue: 0.32, alpha: 1.0)
        static let purpleColor = UIColor(red: 0.72, green: 0.62, blue: 0.97, alpha: 1.0)
        static let limeColor = UIColor(red: 0.86, green: 0.90, blue: 0.12, alpha: 1.0)
    }

    private let viewModel: HomeViewModel
    private let greetingLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchContainerView = UIView()
    private let searchIconView = UIImageView()
    private let searchField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let segmentStackView = UIStackView()
    private let pageContainerView = UIView()
    private let pageViewController: UIPageViewController

    private var segmentButtons: [UIButton] = []
    private var pageControllers: [HomePostsPageViewController] = []
    private var selectedIndex = 0

    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBase()
        configureHeader()
        configureSearch()
        configureSegment()
        configurePages()
        configureLayout()
    }

    private func configureBase() {
        view.backgroundColor = Constants.backgroundColor
        navBar.backgroundColor = .clear
    }

    private func configureHeader() {
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.text = viewModel.greetingTitle
        greetingLabel.font = AppFont.bold(size: 18)
        greetingLabel.textColor = Constants.darkTextColor

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.font = AppFont.medium(size: 12)
        subtitleLabel.textColor = Constants.mutedTextColor

        view.addSubview(greetingLabel)
        view.addSubview(subtitleLabel)
    }

    private func configureSearch() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.backgroundColor = .white
        searchContainerView.layer.cornerRadius = 20
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor(red: 0.78, green: 0.72, blue: 0.98, alpha: 1.0).cgColor

        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(red: 0.78, green: 0.72, blue: 0.98, alpha: 1.0)
        searchIconView.contentMode = .scaleAspectFit

        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = viewModel.searchPlaceholder
        searchField.font = AppFont.medium(size: 11)
        searchField.textColor = Constants.darkTextColor
        searchField.borderStyle = .none
        searchField.backgroundColor = .clear

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle(viewModel.searchButtonTitle, for: .normal)
        searchButton.setTitleColor(UIColor(red: 0.64, green: 0.54, blue: 0.95, alpha: 1.0), for: .normal)
        searchButton.titleLabel?.font = AppFont.medium(size: 11)
        searchButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 1.0, alpha: 1.0)
        searchButton.layer.cornerRadius = 14

        searchContainerView.addSubview(searchIconView)
        searchContainerView.addSubview(searchField)
        searchContainerView.addSubview(searchButton)
        view.addSubview(searchContainerView)
    }

    private func configureSegment() {
        segmentStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentStackView.axis = .horizontal
        segmentStackView.alignment = .fill
        segmentStackView.distribution = .fillEqually
        segmentStackView.spacing = 0

        segmentButtons = viewModel.segments.enumerated().map { index, title in
            let button = UIButton(type: .system)
            button.tag = index
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = AppFont.semibold(size: 12)
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            return button
        }
        segmentButtons.forEach(segmentStackView.addArrangedSubview)
        view.addSubview(segmentStackView)
        updateSegmentSelection()
    }

    private func configurePages() {
        pageContainerView.translatesAutoresizingMaskIntoConstraints = false
        pageControllers = viewModel.segmentPosts.map { HomePostsPageViewController(posts: $0) }

        addChild(pageViewController)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageContainerView.addSubview(pageViewController.view)
        view.addSubview(pageContainerView)
        pageViewController.didMove(toParent: self)

        if let firstController = pageControllers.first {
            pageViewController.setViewControllers([firstController], direction: .forward, animated: false)
        }
    }

    private func configureLayout() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            greetingLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constants.horizontalInset),

            subtitleLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constants.horizontalInset),

            searchContainerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 14),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            searchContainerView.heightAnchor.constraint(equalToConstant: 40),

            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 14),
            searchIconView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 14),
            searchIconView.heightAnchor.constraint(equalToConstant: 14),

            searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -7),
            searchButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 54),
            searchButton.heightAnchor.constraint(equalToConstant: 28),

            searchField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            searchField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),

            segmentStackView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 12),
            segmentStackView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            segmentStackView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            segmentStackView.heightAnchor.constraint(equalToConstant: 28),

            pageContainerView.topAnchor.constraint(equalTo: segmentStackView.bottomAnchor, constant: 4),
            pageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            pageViewController.view.topAnchor.constraint(equalTo: pageContainerView.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageContainerView.bottomAnchor)
        ])
    }

    @objc private func segmentButtonTapped(_ sender: UIButton) {
        let newIndex = sender.tag
        guard newIndex != selectedIndex, pageControllers.indices.contains(newIndex) else {
            return
        }

        let direction: UIPageViewController.NavigationDirection = newIndex > selectedIndex ? .forward : .reverse
        selectedIndex = newIndex
        updateSegmentSelection()
        pageViewController.setViewControllers([pageControllers[newIndex]], direction: direction, animated: true)
    }

    private func updateSegmentSelection() {
        segmentButtons.enumerated().forEach { index, button in
            let isSelected = index == selectedIndex
            let title = viewModel.segments[index]
            let attributes: [NSAttributedString.Key: Any] = [
                .font: AppFont.semibold(size: 12),
                .foregroundColor: Constants.darkTextColor,
                .underlineStyle: isSelected ? NSUnderlineStyle.single.rawValue : 0
            ]
            button.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        }
    }
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageControllers.firstIndex(where: { $0 === viewController }), index > 0 else {
            return nil
        }
        return pageControllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageControllers.firstIndex(where: { $0 === viewController }), index < pageControllers.count - 1 else {
            return nil
        }
        return pageControllers[index + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentController = pageViewController.viewControllers?.first,
              let index = pageControllers.firstIndex(where: { $0 === currentController }) else {
            return
        }
        selectedIndex = index
        updateSegmentSelection()
    }
}

private final class HomePostsPageViewController: UIViewController {
    private let posts: [HomePost]
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(posts: [HomePost]) {
        self.posts = posts
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureLayout()
        updateEmptyState()
    }

    private func configureTableView() {
        view.backgroundColor = HomeViewController.Constants.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.dataSource = self
        tableView.register(HomePostTableViewCell.self, forCellReuseIdentifier: HomePostTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateEmptyState() {
        tableView.backgroundView = posts.isEmpty ? EmptyView(frame: tableView.bounds) : nil
        tableView.isScrollEnabled = !posts.isEmpty
    }
}

extension HomePostsPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HomePostTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? HomePostTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(post: posts[indexPath.row])
        return cell
    }
}

private final class HomePostTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HomePostTableViewCell"

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let authorLabel = UILabel()
    private let metaLabel = UILabel()
    private let moreImageView = UIImageView()
    private let bodyLabel = UILabel()
    private let heroImageView = UIImageView()
    private let thumbnailsStackView = UIStackView()
    private let hotImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailsStackView.arrangedSubviews.forEach { view in
            thumbnailsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    func configure(post: HomePost) {
        cardView.backgroundColor = post.backgroundColor
        avatarImageView.image = UIImage(named: post.avatarImageName)
        authorLabel.text = post.author
        authorLabel.textColor = post.primaryTextColor
        metaLabel.text = "\(post.school)  -  \(post.time)"
        metaLabel.textColor = post.secondaryTextColor
        bodyLabel.text = post.body
        bodyLabel.textColor = post.primaryTextColor
        heroImageView.image = UIImage(named: post.heroImageName)
        hotImageView.isHidden = !post.isHot

        post.thumbnailImageNames.map(makeThumbnailImageView(imageName:)).forEach(thumbnailsStackView.addArrangedSubview)
    }

    private func configureViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 18
        cardView.clipsToBounds = true

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 19
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = AppFont.bold(size: 13)

        metaLabel.translatesAutoresizingMaskIntoConstraints = false
        metaLabel.font = AppFont.medium(size: 10)

        moreImageView.translatesAutoresizingMaskIntoConstraints = false
        moreImageView.image = UIImage(named: "more") ?? UIImage(systemName: "ellipsis")
        moreImageView.tintColor = .white
        moreImageView.contentMode = .scaleAspectFit

        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = AppFont.medium(size: 12)
        bodyLabel.numberOfLines = 0

        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.layer.cornerRadius = 8
        heroImageView.clipsToBounds = true

        thumbnailsStackView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailsStackView.axis = .horizontal
        thumbnailsStackView.distribution = .fillEqually
        thumbnailsStackView.spacing = 4

        hotImageView.translatesAutoresizingMaskIntoConstraints = false
        hotImageView.image = UIImage(named: "hot")
        hotImageView.contentMode = .scaleAspectFit

        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(authorLabel)
        cardView.addSubview(metaLabel)
        cardView.addSubview(moreImageView)
        cardView.addSubview(bodyLabel)
        cardView.addSubview(heroImageView)
        cardView.addSubview(thumbnailsStackView)
        cardView.addSubview(hotImageView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HomeViewController.Constants.horizontalInset),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HomeViewController.Constants.horizontalInset),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            avatarImageView.widthAnchor.constraint(equalToConstant: 38),
            avatarImageView.heightAnchor.constraint(equalToConstant: 38),

            authorLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 2),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreImageView.leadingAnchor, constant: -12),

            metaLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 3),
            metaLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            metaLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreImageView.leadingAnchor, constant: -12),

            moreImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            moreImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            moreImageView.widthAnchor.constraint(equalToConstant: 18),
            moreImageView.heightAnchor.constraint(equalToConstant: 18),

            bodyLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            heroImageView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            heroImageView.leadingAnchor.constraint(equalTo: bodyLabel.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: bodyLabel.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor, multiplier: 0.48),

            thumbnailsStackView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 4),
            thumbnailsStackView.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor),
            thumbnailsStackView.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor),
            thumbnailsStackView.heightAnchor.constraint(equalToConstant: 58),
            thumbnailsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            hotImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -2),
            hotImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -4),
            hotImageView.widthAnchor.constraint(equalToConstant: 48),
            hotImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func makeThumbnailImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
