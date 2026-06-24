import UIKit

final class HomeViewController: BaseViewController {
    private enum Constants {
        static let horizontalInset: CGFloat = 20
        static let cornerRadius: CGFloat = 18
    }

    private let viewModel: HomeViewModel
    private let contentView = UIView()
    private let locationLabel = UILabel()
    private let searchContainerView = UIView()
    private let searchIconView = UIImageView()
    private let searchField = UITextField()
    private let featuredCardView = UIView()
    private let featuredImageView = UIImageView()
    private let featuredTitleLabel = UILabel()
    private let featuredSubtitleLabel = UILabel()
    private let categoryStackView = UIStackView()
    private let postsStackView = UIStackView()

    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHeader()
        configureSearch()
        configureFeaturedCard()
        configureCategories()
        configurePosts()
        configureLayout()
    }



    private func configureHeader() {
        self.changeNavbar(.title)
        self.setTitleAndRight(title: viewModel.title, right: nil)

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = viewModel.locationTitle
        locationLabel.font = AppFont.medium(size: 12)
        locationLabel.textColor = UIColor(red: 0.48, green: 0.41, blue: 0.36, alpha: 1.0)
        view.addSubview(contentView)
        contentView.addSubview(locationLabel)
    }

    private func configureSearch() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        searchContainerView.layer.cornerRadius = 22
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor(red: 196/255, green: 187/255, blue: 254/255, alpha: 1.0).cgColor
        searchContainerView.layer.shadowColor = UIColor.black.cgColor
        searchContainerView.layer.shadowOpacity = 0.06
        searchContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        searchContainerView.layer.shadowRadius = 12

        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(red: 0.53, green: 0.48, blue: 0.44, alpha: 1.0)
        searchIconView.contentMode = .scaleAspectFit

        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = viewModel.searchPlaceholder
        searchField.font = AppFont.medium(size: 16)
        searchField.textColor = .white
        searchField.backgroundColor = .clear

        searchContainerView.addSubview(searchIconView)
        searchContainerView.addSubview(searchField)
        contentView.addSubview(searchContainerView)
    }

    private func configureFeaturedCard() {
        featuredCardView.translatesAutoresizingMaskIntoConstraints = false
        featuredCardView.backgroundColor = UIColor(red: 0.70, green: 0.60, blue: 0.96, alpha: 1.0)
        featuredCardView.layer.cornerRadius = 24
        featuredCardView.clipsToBounds = true

        featuredImageView.translatesAutoresizingMaskIntoConstraints = false
        featuredImageView.image = UIImage(named: "build")
        featuredImageView.contentMode = .scaleAspectFill
        featuredImageView.layer.cornerRadius = Constants.cornerRadius
        featuredImageView.clipsToBounds = true

        featuredTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredTitleLabel.text = viewModel.featuredTitle
        featuredTitleLabel.font = AppFont.bold(size: 18)
        featuredTitleLabel.textColor = .white
        featuredTitleLabel.numberOfLines = 2

        featuredSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredSubtitleLabel.text = viewModel.featuredSubtitle
        featuredSubtitleLabel.font = AppFont.medium(size: 12)
        featuredSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.82)
        featuredSubtitleLabel.numberOfLines = 2

        featuredCardView.addSubview(featuredImageView)
        featuredCardView.addSubview(featuredTitleLabel)
        featuredCardView.addSubview(featuredSubtitleLabel)
        contentView.addSubview(featuredCardView)
    }

    private func configureCategories() {
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 10
        categoryStackView.distribution = .fillEqually

        viewModel.categoryTitles.map { makeCategoryButton(title: $0) }.forEach(categoryStackView.addArrangedSubview)
        contentView.addSubview(categoryStackView)
    }

    private func configurePosts() {
        postsStackView.translatesAutoresizingMaskIntoConstraints = false
        postsStackView.axis = .vertical
        postsStackView.spacing = 14

        viewModel.posts.map { PostCardView(post: $0) }.forEach(postsStackView.addArrangedSubview)
        contentView.addSubview(postsStackView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            locationLabel.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),

            searchContainerView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            searchContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            searchContainerView.heightAnchor.constraint(equalToConstant: 46),

            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16),
            searchIconView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 18),
            searchIconView.heightAnchor.constraint(equalToConstant: 18),

            searchField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 10),
            searchField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16),
            searchField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),

            featuredCardView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 18),
            featuredCardView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            featuredCardView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            featuredCardView.heightAnchor.constraint(equalToConstant: 210),

            featuredImageView.topAnchor.constraint(equalTo: featuredCardView.topAnchor, constant: 14),
            featuredImageView.leadingAnchor.constraint(equalTo: featuredCardView.leadingAnchor, constant: 14),
            featuredImageView.trailingAnchor.constraint(equalTo: featuredCardView.trailingAnchor, constant: -14),
            featuredImageView.heightAnchor.constraint(equalToConstant: 118),

            featuredTitleLabel.topAnchor.constraint(equalTo: featuredImageView.bottomAnchor, constant: 14),
            featuredTitleLabel.leadingAnchor.constraint(equalTo: featuredImageView.leadingAnchor),
            featuredTitleLabel.trailingAnchor.constraint(equalTo: featuredImageView.trailingAnchor),

            featuredSubtitleLabel.topAnchor.constraint(equalTo: featuredTitleLabel.bottomAnchor, constant: 6),
            featuredSubtitleLabel.leadingAnchor.constraint(equalTo: featuredImageView.leadingAnchor),
            featuredSubtitleLabel.trailingAnchor.constraint(equalTo: featuredImageView.trailingAnchor),

            categoryStackView.topAnchor.constraint(equalTo: featuredCardView.bottomAnchor, constant: 18),
            categoryStackView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            categoryStackView.heightAnchor.constraint(equalToConstant: 40),

            postsStackView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 18),
            postsStackView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            postsStackView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            postsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func makeCategoryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0), for: .normal)
        button.titleLabel?.font = AppFont.semibold(size: 12)
        button.backgroundColor = UIColor(red: 0.87, green: 0.92, blue: 0.09, alpha: 1.0)
        button.layer.cornerRadius = 20
        return button
    }
}

private final class PostCardView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tagLabel = UILabel()

    init(post: HomePost) {
        super.init(frame: .zero)

        configure(post: post)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func configure(post: HomePost) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 18
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 14

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: post.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = post.title
        titleLabel.font = AppFont.bold(size: 15)
        titleLabel.textColor = UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0)
        titleLabel.numberOfLines = 2

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = post.subtitle
        subtitleLabel.font = AppFont.medium(size: 11)
        subtitleLabel.textColor = UIColor(red: 0.55, green: 0.49, blue: 0.44, alpha: 1.0)
        subtitleLabel.numberOfLines = 2

        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.text = post.tag
        tagLabel.font = AppFont.bold(size: 10)
        tagLabel.textColor = UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0)
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor(red: 0.87, green: 0.92, blue: 0.09, alpha: 1.0)
        tagLabel.layer.cornerRadius = 12
        tagLabel.clipsToBounds = true

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(tagLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 104),

            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            imageView.widthAnchor.constraint(equalToConstant: 96),

            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            tagLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 62),
            tagLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
