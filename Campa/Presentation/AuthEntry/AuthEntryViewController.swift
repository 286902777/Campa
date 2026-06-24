import UIKit

final class AuthEntryViewController: UIViewController {
    private enum Constants {
        static let horizontalInset: CGFloat = 48
        static let primaryButtonHeight: CGFloat = 56
        static let logoSize: CGFloat = 74
    }

    private let viewModel: AuthEntryViewModel
    private let logoImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let loginByEmailButton = UIButton(type: .system)
    private let newUserButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    private let dividerStackView = UIStackView()
    private let leftDividerView = UIView()
    private let otherLoginMethodsLabel = UILabel()
    private let rightDividerView = UIView()
    private let appleButton = UIButton(type: .system)
    private let agreementStackView = UIStackView()
    private let agreementButton = UIButton(type: .custom)
    private let agreementLabel = UILabel()
    private var isAgreementSelected = false

    init(viewModel: AuthEntryViewModel = AuthEntryViewModel()) {
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
        configureLogo()
        configureAppNameLabel()
        configureButtons()
        configureDivider()
        configureAgreement()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func configureView() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.86, alpha: 1.0)
    }

    private func configureLogo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.accessibilityIdentifier = "authEntryLogoImageView"
    }

    private func configureAppNameLabel() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.text = viewModel.appName
        appNameLabel.font = AppFont.semibold(size: 30)
        appNameLabel.textColor = UIColor(red: 0.25, green: 0.12, blue: 0.08, alpha: 1.0)
        appNameLabel.textAlignment = .center
    }

    private func configureButtons() {
        configureFilledButton(
            loginByEmailButton,
            title: viewModel.loginByEmailTitle,
            backgroundColor: UIColor(red: 0.28, green: 0.02, blue: 0.01, alpha: 1.0),
            titleColor: .white
        )
        loginByEmailButton.accessibilityIdentifier = "loginByEmailButton"
        loginByEmailButton.addTarget(self, action: #selector(handleLoginByEmailTapped), for: .touchUpInside)

        configureFilledButton(
            newUserButton,
            title: viewModel.newUserTitle,
            backgroundColor: UIColor(red: 0.69, green: 0.59, blue: 0.96, alpha: 1.0),
            titleColor: UIColor(red: 0.28, green: 0.02, blue: 0.01, alpha: 1.0)
        )
        newUserButton.accessibilityIdentifier = "newUserButton"
        newUserButton.addTarget(self, action: #selector(handleNewUserTapped), for: .touchUpInside)

        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle(viewModel.signUpPrompt, for: .normal)
        signUpButton.setTitleColor(UIColor(red: 0.27, green: 0.18, blue: 0.14, alpha: 1.0), for: .normal)
        signUpButton.titleLabel?.font = AppFont.regular(size: 11)
        signUpButton.accessibilityIdentifier = "signUpPromptButton"

        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.backgroundColor = UIColor(red: 0.13, green: 0.15, blue: 0.16, alpha: 1.0)
        appleButton.layer.cornerRadius = 22
        appleButton.setImage(UIImage(named: "apple"), for: .normal)
        appleButton.tintColor = .white
        appleButton.accessibilityIdentifier = "appleLoginButton"
    }

    private func configureFilledButton(
        _ button: UIButton,
        title: String,
        backgroundColor: UIColor,
        titleColor: UIColor
    ) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = AppFont.semibold(size: 16)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = Constants.primaryButtonHeight / 2
    }

    private func configureDivider() {
        dividerStackView.translatesAutoresizingMaskIntoConstraints = false
        dividerStackView.axis = .horizontal
        dividerStackView.alignment = .center
        dividerStackView.spacing = 8

        [leftDividerView, rightDividerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor(red: 0.55, green: 0.47, blue: 0.39, alpha: 0.35)
        }

        otherLoginMethodsLabel.translatesAutoresizingMaskIntoConstraints = false
        otherLoginMethodsLabel.text = viewModel.otherLoginMethodsTitle
        otherLoginMethodsLabel.font = AppFont.regular(size: 10)
        otherLoginMethodsLabel.textColor = UIColor(red: 0.44, green: 0.34, blue: 0.28, alpha: 1.0)
        otherLoginMethodsLabel.textAlignment = .center

        dividerStackView.addArrangedSubview(leftDividerView)
        dividerStackView.addArrangedSubview(otherLoginMethodsLabel)
        dividerStackView.addArrangedSubview(rightDividerView)
    }

    private func configureAgreement() {
        agreementStackView.translatesAutoresizingMaskIntoConstraints = false
        agreementStackView.axis = .horizontal
        agreementStackView.alignment = .center
        agreementStackView.spacing = 6

        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        agreementButton.setImage(UIImage(named: "un_select"), for: .normal)
        agreementButton.setImage(UIImage(named: "select"), for: .selected)
        agreementButton.imageView?.contentMode = .scaleAspectFit
        agreementButton.accessibilityIdentifier = "agreementButton"
        agreementButton.addTarget(self, action: #selector(handleAgreementButtonTapped), for: .touchUpInside)

        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementLabel.text = viewModel.agreementTitle
        agreementLabel.font = AppFont.regular(size: 10)
        agreementLabel.textColor = UIColor(red: 0.24, green: 0.20, blue: 0.18, alpha: 1.0)
        agreementLabel.numberOfLines = 1
        agreementLabel.adjustsFontSizeToFitWidth = true
        agreementLabel.minimumScaleFactor = 0.75

        agreementStackView.addArrangedSubview(agreementButton)
        agreementStackView.addArrangedSubview(agreementLabel)
    }

    private func configureLayout() {
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(loginByEmailButton)
        view.addSubview(newUserButton)
        view.addSubview(signUpButton)
        view.addSubview(dividerStackView)
        view.addSubview(appleButton)
        view.addSubview(agreementStackView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 92),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoSize),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 14),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loginByEmailButton.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 84),
            loginByEmailButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalInset),
            loginByEmailButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalInset),
            loginByEmailButton.heightAnchor.constraint(equalToConstant: Constants.primaryButtonHeight),

            newUserButton.topAnchor.constraint(equalTo: loginByEmailButton.bottomAnchor, constant: 18),
            newUserButton.leadingAnchor.constraint(equalTo: loginByEmailButton.leadingAnchor),
            newUserButton.trailingAnchor.constraint(equalTo: loginByEmailButton.trailingAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: Constants.primaryButtonHeight),

            signUpButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 22),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dividerStackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            dividerStackView.leadingAnchor.constraint(equalTo: loginByEmailButton.leadingAnchor),
            dividerStackView.trailingAnchor.constraint(equalTo: loginByEmailButton.trailingAnchor),
            leftDividerView.heightAnchor.constraint(equalToConstant: 1),
            rightDividerView.heightAnchor.constraint(equalToConstant: 1),
            leftDividerView.widthAnchor.constraint(equalTo: rightDividerView.widthAnchor),

            appleButton.topAnchor.constraint(equalTo: dividerStackView.bottomAnchor, constant: 20),
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.widthAnchor.constraint(equalToConstant: 44),
            appleButton.heightAnchor.constraint(equalTo: appleButton.widthAnchor),

            agreementStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            agreementStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            agreementStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            agreementStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28),
            agreementButton.widthAnchor.constraint(equalToConstant: 24),
            agreementButton.heightAnchor.constraint(equalTo: agreementButton.widthAnchor)
        ])
    }

    @objc private func handleLoginByEmailTapped() {
        guard guardAgreementSelected() else {
            return
        }

        navigationController?.pushViewController(LoginViewController(), animated: true)
    }

    @objc private func handleAgreementButtonTapped() {
        isAgreementSelected.toggle()
        agreementButton.isSelected = isAgreementSelected
    }

    @objc private func handleNewUserTapped() {
        guard guardAgreementSelected() else {
            return
        }

        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    private func guardAgreementSelected() -> Bool {
        guard isAgreementSelected else {
            showToast(message: NSLocalizedString("Please agree first", comment: "Agreement required toast"))
            return false
        }

        return true
    }

    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.font = AppFont.medium(size: 13)
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        toastLabel.layer.cornerRadius = 18
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 0
        toastLabel.accessibilityIdentifier = "agreementToastLabel"

        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: agreementStackView.topAnchor, constant: -24),
            toastLabel.heightAnchor.constraint(equalToConstant: 36),
            toastLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])

        UIView.animate(withDuration: 0.2, animations: {
            toastLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 1.4, options: [], animations: {
                toastLabel.alpha = 0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
