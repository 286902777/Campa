import UIKit

final class CampusViewController: BaseViewController {
    fileprivate enum Constants {
        static let backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.86, alpha: 1.0)
        static let purpleColor = UIColor(red: 0.72, green: 0.62, blue: 0.97, alpha: 1.0)
        static let limeColor = UIColor(red: 0.86, green: 0.90, blue: 0.12, alpha: 1.0)
        static let darkTextColor = UIColor(red: 52/255.0, green: 4/255, blue: 4/255.0, alpha: 1.0)
        static let horizontalInset: CGFloat = 24
    }

    private let titleLabel = UILabel()
    private let locationIconView = UIImageView()
    private let locationLabel = UILabel()
    private let starContainerView = UIImageView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    private let activities: [CampusActivity] = [
        CampusActivity(imageName: "build", title: "Yonsei Spring Festival", date: "May 24 | Fri 10:00 AM", campus: "Yonsei Main Campus"),
        CampusActivity(imageName: "build_sel", title: "Yonsei Spring Festival", date: "May 24 | Fri 10:00 AM", campus: "Yonsei Main Campus"),
        CampusActivity(imageName: "photo", title: "Yonsei Spring Festival", date: "May 24 | Fri 10:00 AM", campus: "Yonsei Main Campus"),
        CampusActivity(imageName: "build", title: "Yonsei Spring Festival", date: "May 24 | Fri 10:00 AM", campus: "Yonsei Main Campus")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureHeader()
        configureTableView()
        configureLayout()
    }

    private func configureView() {
        view.backgroundColor = Constants.backgroundColor
        navBar.backgroundColor = .clear
    }

    private func configureHeader() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = NSLocalizedString("Campus", comment: "Campus screen title")
        titleLabel.font = AppFont.bold(size: 20)
        titleLabel.textColor = Constants.darkTextColor

        locationIconView.translatesAutoresizingMaskIntoConstraints = false
        locationIconView.image = UIImage(named: "location")
        locationIconView.contentMode = .scaleAspectFit

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = NSLocalizedString("Seoul, Korea", comment: "Campus location")
        locationLabel.font = AppFont.medium(size: 10)
        locationLabel.textColor = Constants.darkTextColor

        starContainerView.translatesAutoresizingMaskIntoConstraints = false
        starContainerView.backgroundColor = .clear
        starContainerView.layer.borderColor = UIColor(red: 0.45, green: 0.36, blue: 0.30, alpha: 0.45).cgColor
        starContainerView.image = UIImage(named: "star")
        starContainerView.contentMode = .scaleAspectFill

        view.addSubview(titleLabel)
        view.addSubview(locationIconView)
        view.addSubview(locationLabel)
        view.addSubview(starContainerView)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 120, right: 0)
        tableView.dataSource = self
        tableView.register(CampusActivityTableViewCell.self, forCellReuseIdentifier: CampusActivityTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: starContainerView.leadingAnchor, constant: -16),

            locationIconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            locationIconView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationIconView.widthAnchor.constraint(equalToConstant: 12),
            locationIconView.heightAnchor.constraint(equalToConstant: 12),

            locationLabel.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 5),
            locationLabel.centerYAnchor.constraint(equalTo: locationIconView.centerYAnchor),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: starContainerView.leadingAnchor, constant: -16),

            starContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            starContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            starContainerView.widthAnchor.constraint(equalToConstant: 88),
            starContainerView.heightAnchor.constraint(equalToConstant: 29),

            tableView.topAnchor.constraint(equalTo: locationIconView.bottomAnchor, constant: 28),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CampusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CampusActivityTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CampusActivityTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(activity: activities[indexPath.row])
        return cell
    }
}

private struct CampusActivity {
    let imageName: String
    let title: String
    let date: String
    let campus: String
}

private final class CampusActivityTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CampusActivityTableViewCell"

    private let cardView = UIView()
    private let activityImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationIconView = UIImageView()
    private let campusLabel = UILabel()
    private let joinButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(activity: CampusActivity) {
        activityImageView.image = UIImage(named: activity.imageName)
        titleLabel.text = activity.title
        dateLabel.text = activity.date
        campusLabel.text = activity.campus
    }

    private func configureViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = CampusViewController.Constants.purpleColor
        cardView.layer.cornerRadius = 14
        cardView.clipsToBounds = true

        activityImageView.translatesAutoresizingMaskIntoConstraints = false
        activityImageView.contentMode = .scaleAspectFill
        activityImageView.layer.cornerRadius = 10
        activityImageView.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AppFont.bold(size: 13)
        titleLabel.textColor = .white

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = AppFont.medium(size: 9)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.82)

        locationIconView.translatesAutoresizingMaskIntoConstraints = false
        locationIconView.image = UIImage(named: "location")
        locationIconView.contentMode = .scaleAspectFit

        campusLabel.translatesAutoresizingMaskIntoConstraints = false
        campusLabel.font = AppFont.medium(size: 9)
        campusLabel.textColor = UIColor.white.withAlphaComponent(0.86)

        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.setTitle(NSLocalizedString("+ Join", comment: "Join campus activity button"), for: .normal)
        joinButton.setTitleColor(CampusViewController.Constants.darkTextColor, for: .normal)
        joinButton.titleLabel?.font = AppFont.bold(size: 12)
        joinButton.backgroundColor = CampusViewController.Constants.limeColor
        joinButton.layer.cornerRadius = 15

        contentView.addSubview(cardView)
        cardView.addSubview(activityImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(locationIconView)
        cardView.addSubview(campusLabel)
        cardView.addSubview(joinButton)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CampusViewController.Constants.horizontalInset),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CampusViewController.Constants.horizontalInset),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.heightAnchor.constraint(equalToConstant: 100),

            activityImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            activityImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            activityImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            activityImageView.widthAnchor.constraint(equalToConstant: 94),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: activityImageView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -14),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -14),

            locationIconView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationIconView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -17),
            locationIconView.widthAnchor.constraint(equalToConstant: 11),
            locationIconView.heightAnchor.constraint(equalToConstant: 11),

            campusLabel.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 5),
            campusLabel.centerYAnchor.constraint(equalTo: locationIconView.centerYAnchor),
            campusLabel.trailingAnchor.constraint(lessThanOrEqualTo: joinButton.leadingAnchor, constant: -10),

            joinButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            joinButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            joinButton.widthAnchor.constraint(equalToConstant: 62),
            joinButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
