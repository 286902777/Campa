import XCTest
@testable import Campa

final class HomeViewModelTests: XCTestCase {
    func testTitleReturnsAppName() {
        let viewModel = HomeViewModel()

        XCTAssertEqual(viewModel.title, "Campa")
    }
}

final class SplashViewModelTests: XCTestCase {
    func testSplashContentMatchesFirstDesignPage() {
        let viewModel = SplashViewModel()

        XCTAssertEqual(viewModel.title, "Campa")
        XCTAssertEqual(viewModel.logoText, "C")
    }
}

final class LoginViewModelTests: XCTestCase {
    func testLoginContentMatchesDesign() {
        let viewModel = LoginViewModel()

        XCTAssertEqual(viewModel.title, "Sign in")
        XCTAssertEqual(viewModel.emailPlaceholder, "Email")
        XCTAssertEqual(viewModel.passwordPlaceholder, "Password")
        XCTAssertEqual(viewModel.forgotPasswordTitle, "Forget ?")
        XCTAssertEqual(viewModel.loginButtonTitle, "Login")
    }
}

final class AuthEntryViewModelTests: XCTestCase {
    func testAuthEntryContentMatchesDesign() {
        let viewModel = AuthEntryViewModel()

        XCTAssertEqual(viewModel.appName, "Campa")
        XCTAssertEqual(viewModel.loginByEmailTitle, "Login by email")
        XCTAssertEqual(viewModel.newUserTitle, "I'm new")
        XCTAssertEqual(viewModel.signUpPrompt, "Don't have an account? Sign up")
        XCTAssertEqual(viewModel.otherLoginMethodsTitle, "Other login methods")
        XCTAssertEqual(viewModel.agreementTitle, "Agree with User Agreement and Privacy Policy")
    }
}
