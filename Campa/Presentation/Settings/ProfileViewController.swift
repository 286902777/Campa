import SnapKit
import UIKit

final class ProfileViewController: BaseViewController {
    private enum Constants {
        static let backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.86, alpha: 1.0)
        static let purpleColor = UIColor(red: 0.69, green: 0.59, blue: 0.96, alpha: 1.0)
        static let darkTextColor = UIColor(red: 0.28, green: 0.02, blue: 0.01, alpha: 1.0)
        static let mutedTextColor = UIColor(red: 0.42, green: 0.36, blue: 0.32, alpha: 1.0)
    }

    private let viewModel: ProfileViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerImageView = UIImageView()
    private let profilePanelView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let schoolLabel = UILabel()
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

    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
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
    }

    override func rightAction() {
        let vc = SettingsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configure() {
        view.backgroundColor = Constants.backgroundColor
        self.navType = .titleRightBtn
        self.setTitleAndRight(title: nil, right: "set", rightSize: CGSize(width: 30, height: 30))
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
    }

    private func configureHeader() {
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.backgroundColor = .red
        headerImageView.clipsToBounds = true
    }

    private func configureProfilePanel() {
        profilePanelView.translatesAutoresizingMaskIntoConstraints = false
        profilePanelView.backgroundColor = Constants.backgroundColor
        profilePanelView.layer.cornerRadius = 34
        profilePanelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "user_icon")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 46
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = viewModel.name
        nameLabel.font = AppFont.bold(size: 26)
        nameLabel.textColor = Constants.darkTextColor

        schoolLabel.translatesAutoresizingMaskIntoConstraints = false
        schoolLabel.text = viewModel.school
        schoolLabel.font = AppFont.semibold(size: 20)
        schoolLabel.textColor = Constants.mutedTextColor

        locationIconView.translatesAutoresizingMaskIntoConstraints = false
        locationIconView.image = UIImage(named: "location")
        locationIconView.contentMode = .scaleAspectFit
        locationIconView.tintColor = Constants.mutedTextColor

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = viewModel.location
        locationLabel.font = AppFont.medium(size: 14)
        locationLabel.textColor = Constants.mutedTextColor

        statsStackView.translatesAutoresizingMaskIntoConstraints = false
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

    private func configurePostCard() {
        postCardView.translatesAutoresizingMaskIntoConstraints = false
        postCardView.backgroundColor = Constants.purpleColor
        postCardView.layer.cornerRadius = 24
        postCardView.clipsToBounds = true

        postAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        postAvatarImageView.image = UIImage(named: "user_icon")
        postAvatarImageView.backgroundColor = .white
        postAvatarImageView.contentMode = .scaleAspectFill
        postAvatarImageView.layer.cornerRadius = 27
        postAvatarImageView.layer.borderColor = UIColor.white.cgColor
        postAvatarImageView.layer.borderWidth = 2
        postAvatarImageView.clipsToBounds = true

        postNameLabel.translatesAutoresizingMaskIntoConstraints = false
        postNameLabel.text = viewModel.postAuthor
        postNameLabel.font = AppFont.semibold(size: 20)
        postNameLabel.textColor = .white

        postMetaLabel.translatesAutoresizingMaskIntoConstraints = false
        postMetaLabel.text = "\(viewModel.postSchool)  •  \(viewModel.postTime)"
        postMetaLabel.font = AppFont.medium(size: 12)
        postMetaLabel.textColor = UIColor.white.withAlphaComponent(0.82)

        postBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        postBodyLabel.text = viewModel.postText
        postBodyLabel.font = AppFont.medium(size: 14)
        postBodyLabel.textColor = .white
        postBodyLabel.numberOfLines = 0

        postHeroImageView.translatesAutoresizingMaskIntoConstraints = false
        postHeroImageView.contentMode = .scaleAspectFill
        postHeroImageView.clipsToBounds = true
        postHeroImageView.layer.cornerRadius = 8
        postHeroImageView.backgroundColor = .blue
        thumbnailStackView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailStackView.axis = .horizontal
        thumbnailStackView.distribution = .fillEqually
        thumbnailStackView.spacing = 4

        [
            UIColor(red: 0.70, green: 0.80, blue: 0.76, alpha: 1.0),
            UIColor(red: 0.78, green: 0.84, blue: 0.85, alpha: 1.0),
            UIColor(red: 0.58, green: 0.70, blue: 0.44, alpha: 1.0)
        ].map(makeThumbnailView(color:)).forEach(thumbnailStackView.addArrangedSubview)
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.bringSubviewToFront(navBar)
        contentView.addSubview(headerImageView)
        contentView.addSubview(profilePanelView)
        contentView.addSubview(avatarImageView)
        profilePanelView.addSubview(statsStackView)
        profilePanelView.addSubview(nameLabel)
        profilePanelView.addSubview(schoolLabel)
        profilePanelView.addSubview(locationIconView)
        profilePanelView.addSubview(locationLabel)
        profilePanelView.addSubview(postCardView)
        postCardView.addSubview(postAvatarImageView)
        postCardView.addSubview(postNameLabel)
        postCardView.addSubview(postMetaLabel)
        postCardView.addSubview(postBodyLabel)
        postCardView.addSubview(postHeroImageView)
        postCardView.addSubview(thumbnailStackView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.36)
        }

        profilePanelView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(-42)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(postCardView.snp.bottom).offset(108)
            make.bottom.equalToSuperview()
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
            make.top.equalTo(statsStackView.snp.bottom).offset(16)
            make.leading.equalTo(profilePanelView.snp.leading).offset(48)
            make.trailing.lessThanOrEqualTo(profilePanelView.snp.trailing).inset(28)
        }

        schoolLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel.snp.leading)
        }

        locationIconView.snp.makeConstraints { make in
            make.leading.equalTo(schoolLabel.snp.trailing).offset(12)
            make.centerY.equalTo(schoolLabel.snp.centerY)
            make.size.equalTo(18)
        }

        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIconView.snp.trailing).offset(6)
            make.centerY.equalTo(schoolLabel.snp.centerY)
            make.trailing.lessThanOrEqualTo(profilePanelView.snp.trailing).inset(26)
        }

        postCardView.snp.makeConstraints { make in
            make.top.equalTo(schoolLabel.snp.bottom).offset(34)
            make.leading.trailing.equalTo(profilePanelView).inset(30)
        }

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
            make.bottom.equalToSuperview().inset(22)
        }
    }

    private func makeStatView(count: String, title: String) -> UIView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
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

    private func makeThumbnailView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }
}
