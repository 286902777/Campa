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
    private let headerImageView = ScenicImageView()
    private let cameraButton = UIButton(type: .system)
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
    private let postHeroImageView = CherryRoadImageView()
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

        navBar.isHidden = true
        configureScrollView()
        configureHeader()
        configureProfilePanel()
        configurePostCard()
        configureLayout()
    }

    private func configureScrollView() {
        view.backgroundColor = Constants.backgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureHeader() {
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true

        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.backgroundColor = .white
        cameraButton.tintColor = Constants.darkTextColor
        cameraButton.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        cameraButton.layer.cornerRadius = 27
        cameraButton.layer.shadowColor = UIColor.black.cgColor
        cameraButton.layer.shadowOpacity = 0.08
        cameraButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        cameraButton.layer.shadowRadius = 10
        cameraButton.accessibilityIdentifier = "profileCameraButton"
    }

    private func configureProfilePanel() {
        profilePanelView.translatesAutoresizingMaskIntoConstraints = false
        profilePanelView.backgroundColor = Constants.backgroundColor
        profilePanelView.layer.cornerRadius = 34
        profilePanelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "user_icon")
        avatarImageView.backgroundColor = .white
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 56
        avatarImageView.layer.borderWidth = 4
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true

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
        postAvatarImageView.layer.borderWidth = 3
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

        thumbnailStackView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailStackView.axis = .horizontal
        thumbnailStackView.distribution = .fillEqually
        thumbnailStackView.spacing = 4

        [0, 1, 2].map { CampusThumbnailView(style: $0) }.forEach(thumbnailStackView.addArrangedSubview)
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerImageView)
        contentView.addSubview(cameraButton)
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

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.36),

            cameraButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            cameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cameraButton.widthAnchor.constraint(equalToConstant: 54),
            cameraButton.heightAnchor.constraint(equalToConstant: 54),

            profilePanelView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -42),
            profilePanelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profilePanelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profilePanelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 62),
            avatarImageView.centerYAnchor.constraint(equalTo: profilePanelView.topAnchor, constant: -16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 112),
            avatarImageView.heightAnchor.constraint(equalToConstant: 112),

            statsStackView.topAnchor.constraint(equalTo: profilePanelView.topAnchor, constant: 26),
            statsStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            statsStackView.trailingAnchor.constraint(equalTo: profilePanelView.trailingAnchor, constant: -26),
            statsStackView.heightAnchor.constraint(equalToConstant: 54),

            nameLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: profilePanelView.leadingAnchor, constant: 48),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: profilePanelView.trailingAnchor, constant: -28),

            schoolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            schoolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            locationIconView.leadingAnchor.constraint(equalTo: schoolLabel.trailingAnchor, constant: 12),
            locationIconView.centerYAnchor.constraint(equalTo: schoolLabel.centerYAnchor),
            locationIconView.widthAnchor.constraint(equalToConstant: 18),
            locationIconView.heightAnchor.constraint(equalToConstant: 18),

            locationLabel.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 6),
            locationLabel.centerYAnchor.constraint(equalTo: schoolLabel.centerYAnchor),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: profilePanelView.trailingAnchor, constant: -26),

            postCardView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 34),
            postCardView.leadingAnchor.constraint(equalTo: profilePanelView.leadingAnchor, constant: 30),
            postCardView.trailingAnchor.constraint(equalTo: profilePanelView.trailingAnchor, constant: -30),
            postCardView.bottomAnchor.constraint(equalTo: profilePanelView.bottomAnchor, constant: -108),

            postAvatarImageView.topAnchor.constraint(equalTo: postCardView.topAnchor, constant: 22),
            postAvatarImageView.leadingAnchor.constraint(equalTo: postCardView.leadingAnchor, constant: 22),
            postAvatarImageView.widthAnchor.constraint(equalToConstant: 54),
            postAvatarImageView.heightAnchor.constraint(equalToConstant: 54),

            postNameLabel.topAnchor.constraint(equalTo: postAvatarImageView.topAnchor, constant: 2),
            postNameLabel.leadingAnchor.constraint(equalTo: postAvatarImageView.trailingAnchor, constant: 14),
            postNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: postCardView.trailingAnchor, constant: -18),

            postMetaLabel.topAnchor.constraint(equalTo: postNameLabel.bottomAnchor, constant: 4),
            postMetaLabel.leadingAnchor.constraint(equalTo: postNameLabel.leadingAnchor),
            postMetaLabel.trailingAnchor.constraint(lessThanOrEqualTo: postCardView.trailingAnchor, constant: -18),

            postBodyLabel.topAnchor.constraint(equalTo: postAvatarImageView.bottomAnchor, constant: 20),
            postBodyLabel.leadingAnchor.constraint(equalTo: postCardView.leadingAnchor, constant: 22),
            postBodyLabel.trailingAnchor.constraint(equalTo: postCardView.trailingAnchor, constant: -22),

            postHeroImageView.topAnchor.constraint(equalTo: postBodyLabel.bottomAnchor, constant: 18),
            postHeroImageView.leadingAnchor.constraint(equalTo: postBodyLabel.leadingAnchor),
            postHeroImageView.trailingAnchor.constraint(equalTo: postBodyLabel.trailingAnchor),
            postHeroImageView.heightAnchor.constraint(equalTo: postHeroImageView.widthAnchor, multiplier: 0.56),

            thumbnailStackView.topAnchor.constraint(equalTo: postHeroImageView.bottomAnchor, constant: 4),
            thumbnailStackView.leadingAnchor.constraint(equalTo: postHeroImageView.leadingAnchor),
            thumbnailStackView.trailingAnchor.constraint(equalTo: postHeroImageView.trailingAnchor),
            thumbnailStackView.heightAnchor.constraint(equalTo: postHeroImageView.heightAnchor, multiplier: 0.32),
            thumbnailStackView.bottomAnchor.constraint(equalTo: postCardView.bottomAnchor, constant: -22)
        ])
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
}

private final class ScenicImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.62, green: 0.72, blue: 0.70, alpha: 1.0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let skyColor = UIColor(red: 0.57, green: 0.70, blue: 0.72, alpha: 1.0).cgColor
        let wallColor = UIColor(red: 0.42, green: 0.47, blue: 0.43, alpha: 1.0).cgColor
        let waterColor = UIColor(red: 0.37, green: 0.56, blue: 0.53, alpha: 1.0).cgColor
        let gradient = CGGradient(colorsSpace: nil, colors: [skyColor, wallColor, waterColor] as CFArray, locations: [0, 0.56, 1])
        context.drawLinearGradient(
            gradient!,
            start: CGPoint(x: rect.midX, y: rect.minY),
            end: CGPoint(x: rect.midX, y: rect.maxY),
            options: []
        )

        UIColor(red: 0.82, green: 0.76, blue: 0.67, alpha: 1.0).setFill()
        UIBezierPath(rect: CGRect(x: rect.minX, y: rect.maxY * 0.62, width: rect.width, height: rect.height * 0.14)).fill()

        UIColor(red: 0.25, green: 0.20, blue: 0.17, alpha: 0.28).setFill()
        UIBezierPath(ovalIn: CGRect(x: rect.midX - 54, y: rect.maxY * 0.18, width: 108, height: 116)).fill()
        UIColor(red: 0.93, green: 0.84, blue: 0.72, alpha: 1.0).setFill()
        UIBezierPath(ovalIn: CGRect(x: rect.midX - 26, y: rect.maxY * 0.23, width: 52, height: 58)).fill()
        UIColor(red: 0.94, green: 0.90, blue: 0.84, alpha: 1.0).setFill()
        UIBezierPath(roundedRect: CGRect(x: rect.midX - 58, y: rect.maxY * 0.43, width: 116, height: 140), cornerRadius: 22).fill()
    }
}

private final class CherryRoadImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.72, green: 0.78, blue: 0.80, alpha: 1.0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func draw(_ rect: CGRect) {
        UIColor(red: 0.78, green: 0.84, blue: 0.85, alpha: 1.0).setFill()
        UIBezierPath(rect: rect).fill()

        UIColor(red: 0.36, green: 0.43, blue: 0.39, alpha: 1.0).setFill()
        UIBezierPath(rect: CGRect(x: 0, y: rect.height * 0.58, width: rect.width, height: rect.height * 0.42)).fill()

        UIColor(red: 0.68, green: 0.68, blue: 0.66, alpha: 1.0).setFill()
        UIBezierPath(rect: CGRect(x: rect.width * 0.31, y: rect.height * 0.50, width: rect.width * 0.38, height: rect.height * 0.50)).fill()

        UIColor.white.withAlphaComponent(0.86).setStroke()
        let centerLine = UIBezierPath()
        centerLine.move(to: CGPoint(x: rect.midX, y: rect.height * 0.54))
        centerLine.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        centerLine.lineWidth = 2
        centerLine.stroke()

        drawTree(in: rect, x: rect.width * 0.15, mirror: false)
        drawTree(in: rect, x: rect.width * 0.85, mirror: true)
        drawCar(in: rect, x: rect.width * 0.58, color: UIColor(red: 0.18, green: 0.50, blue: 0.60, alpha: 1.0))
        drawCar(in: rect, x: rect.width * 0.76, color: UIColor.white)
        drawCar(in: rect, x: rect.width * 0.33, color: UIColor(red: 0.82, green: 0.86, blue: 0.88, alpha: 1.0))
    }

    private func drawTree(in rect: CGRect, x: CGFloat, mirror: Bool) {
        UIColor(red: 0.20, green: 0.14, blue: 0.11, alpha: 1.0).setStroke()
        let trunk = UIBezierPath()
        trunk.move(to: CGPoint(x: x, y: rect.maxY))
        trunk.addLine(to: CGPoint(x: x + (mirror ? -18 : 18), y: rect.height * 0.22))
        trunk.lineWidth = 10
        trunk.stroke()

        UIColor(red: 0.93, green: 0.74, blue: 0.81, alpha: 1.0).setStroke()
        for index in 0..<7 {
            let y = rect.height * CGFloat(0.16 + Double(index) * 0.045)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x + (mirror ? -12 : 12), y: y))
            path.addCurve(
                to: CGPoint(x: rect.midX + CGFloat(index - 3) * 20, y: y + 24),
                controlPoint1: CGPoint(x: x + (mirror ? -60 : 60), y: y - 18),
                controlPoint2: CGPoint(x: rect.midX, y: y - 8)
            )
            path.lineWidth = 8
            path.stroke()
        }
    }

    private func drawCar(in rect: CGRect, x: CGFloat, color: UIColor) {
        color.setFill()
        UIBezierPath(roundedRect: CGRect(x: x - 20, y: rect.height * 0.62, width: 40, height: 24), cornerRadius: 6).fill()
        UIColor.black.withAlphaComponent(0.32).setFill()
        UIBezierPath(ovalIn: CGRect(x: x - 18, y: rect.height * 0.76, width: 10, height: 10)).fill()
        UIBezierPath(ovalIn: CGRect(x: x + 8, y: rect.height * 0.76, width: 10, height: 10)).fill()
    }
}

private final class CampusThumbnailView: UIView {
    private let style: Int

    init(style: Int) {
        self.style = style
        super.init(frame: .zero)
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = UIColor(red: 0.72, green: 0.78, blue: 0.80, alpha: 1.0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func draw(_ rect: CGRect) {
        UIColor(red: 0.70, green: 0.80, blue: 0.76, alpha: 1.0).setFill()
        UIBezierPath(rect: rect).fill()

        switch style {
        case 0:
            UIColor(red: 0.93, green: 0.74, blue: 0.81, alpha: 1.0).setStroke()
            for offset in stride(from: CGFloat(8), through: rect.width, by: 18) {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: offset, y: rect.minY))
                path.addLine(to: CGPoint(x: offset - 22, y: rect.maxY))
                path.lineWidth = 4
                path.stroke()
            }
        case 1:
            UIColor.white.withAlphaComponent(0.80).setStroke()
            for offset in stride(from: CGFloat(-20), through: rect.width + 20, by: 20) {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: offset, y: rect.maxY))
                path.addLine(to: CGPoint(x: offset + 36, y: rect.minY))
                path.lineWidth = 3
                path.stroke()
            }
        default:
            UIColor(red: 0.58, green: 0.70, blue: 0.44, alpha: 1.0).setFill()
            for row in 0..<3 {
                for column in 0..<4 {
                    UIBezierPath(
                        ovalIn: CGRect(x: CGFloat(column) * rect.width / 4 + 8, y: CGFloat(row) * rect.height / 3 + 8, width: 12, height: 12)
                    ).fill()
                }
            }
        }
    }
}
