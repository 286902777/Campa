import UIKit

final class SettingsViewController: BaseViewController {
    fileprivate enum Constants {
        static let horizontalInset: CGFloat = 20
        static let rowHeight: CGFloat = 56
    }

    private let viewModel: SettingsViewModel
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureScrollView()
        configureSections()
        configureLayout()
    }

    private func configureNavigation() {
        changeNavbar(.title)
        setTitleAndRight(title: viewModel.title, right: nil)
        titleL.font = AppFont.bold(size: 24)
    }

    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 18

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }

    private func configureSections() {
        viewModel.sections.map(SettingsSectionView.init(section:)).forEach(contentStackView.addArrangedSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Constants.horizontalInset),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Constants.horizontalInset),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -120),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -Constants.horizontalInset * 2)
        ])
    }
}

private final class SettingsSectionView: UIView {
    private let stackView = UIStackView()

    init(section: SettingsSection) {
        super.init(frame: .zero)

        configure(section: section)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func configure(section: SettingsSection) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white.withAlphaComponent(0.78)
        layer.cornerRadius = 18
        clipsToBounds = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        section.items.enumerated().forEach { index, item in
            stackView.addArrangedSubview(SettingsRowView(item: item, showsDivider: index < section.items.count - 1))
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private final class SettingsRowView: UIView {
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let switchView = UISwitch()
    private let dividerView = UIView()

    init(item: SettingsItem, showsDivider: Bool) {
        super.init(frame: .zero)

        configure(item: item, showsDivider: showsDivider)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func configure(item: SettingsItem, showsDivider: Bool) {
        translatesAutoresizingMaskIntoConstraints = false

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = UIColor(red: 0.70, green: 0.60, blue: 0.96, alpha: 1.0)
        iconContainerView.layer.cornerRadius = 16

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(named: item.iconName)
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = item.title
        titleLabel.font = AppFont.semibold(size: 15)
        titleLabel.textColor = UIColor(red: 0.28, green: 0.20, blue: 0.16, alpha: 1.0)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = AppFont.medium(size: 12)
        valueLabel.textColor = UIColor(red: 0.54, green: 0.48, blue: 0.42, alpha: 1.0)

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "arrow")
        arrowImageView.contentMode = .scaleAspectFit

        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = UIColor(red: 0.70, green: 0.60, blue: 0.96, alpha: 1.0)

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor(red: 0.52, green: 0.44, blue: 0.37, alpha: 0.14)
        dividerView.isHidden = !showsDivider

        addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(arrowImageView)
        addSubview(switchView)
        addSubview(dividerView)

        configureAccessory(item.accessory)
        configureLayout()
    }

    private func configureAccessory(_ accessory: SettingsItem.Accessory) {
        valueLabel.isHidden = true
        arrowImageView.isHidden = true
        switchView.isHidden = true

        switch accessory {
        case .arrow:
            arrowImageView.isHidden = false
        case .switchControl(let isOn):
            switchView.isHidden = false
            switchView.isOn = isOn
        case .value(let value):
            valueLabel.isHidden = false
            valueLabel.text = value
            arrowImageView.isHidden = false
        case .none:
            break
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: SettingsViewController.Constants.rowHeight),

            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            iconContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 32),
            iconContainerView.heightAnchor.constraint(equalToConstant: 32),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: switchView.leadingAnchor, constant: -12),

            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 18),
            arrowImageView.heightAnchor.constraint(equalToConstant: 18),

            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            dividerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
