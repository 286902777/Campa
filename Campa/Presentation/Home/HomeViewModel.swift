import UIKit

final class HomeViewModel {
    private enum Constants {
        static let darkTextColor = UIColor(red: 0.28, green: 0.02, blue: 0.02, alpha: 1.0)
        static let whiteTextColor = UIColor.white
        static let mutedDarkTextColor = UIColor(red: 0.40, green: 0.32, blue: 0.28, alpha: 1.0)
        static let mutedWhiteTextColor = UIColor.white.withAlphaComponent(0.78)
        static let purpleColor = UIColor(red: 0.72, green: 0.62, blue: 0.97, alpha: 1.0)
        static let limeColor = UIColor(red: 0.86, green: 0.90, blue: 0.12, alpha: 1.0)
    }

    let greetingTitle = NSLocalizedString("Good Morning, Jiwoo", comment: "Home greeting title")
    let title = NSLocalizedString("Campa", comment: "App title")
    let subtitle = NSLocalizedString("Connect beyond classrooms.", comment: "Home subtitle")
    let searchPlaceholder = NSLocalizedString("Search posts, people, clubs...", comment: "Home search placeholder")
    let searchButtonTitle = NSLocalizedString("Search", comment: "Home search button")
    let segments = [
        NSLocalizedString("For You", comment: "Home segment"),
        NSLocalizedString("Following", comment: "Home segment"),
        NSLocalizedString("Popular", comment: "Home segment")
    ]

    let segmentPosts: [[HomePost]]

    init() {
        let campusPost = HomePost(
            sourcePost: nil,
            author: "Jiwoo",
            school: "Korea University",
            time: "2 hours ago",
            body: NSLocalizedString(
                "Springtime on campus: the cherry blossoms are in full bloom. welcome to come and take photos!",
                comment: "Home post body"
            ),
            avatarImage: UIImage(named: "user_icon"),
            heroImage: UIImage(named: "build"),
            thumbnailImages: ["build", "photo", "build_sel"].compactMap { UIImage(named: $0) },
            isHot: true,
            backgroundColor: Constants.purpleColor,
            primaryTextColor: Constants.whiteTextColor,
            secondaryTextColor: Constants.mutedWhiteTextColor
        )

        let popularPost = HomePost(
            sourcePost: nil,
            author: "Jiwoo",
            school: "Korea University",
            time: "2 hours ago",
            body: NSLocalizedString(
                "Springtime on campus: the cherry blossoms are in full bloom. welcome to come and take photos!",
                comment: "Home post body"
            ),
            avatarImage: UIImage(named: "user_icon"),
            heroImage: UIImage(named: "photo"),
            thumbnailImages: ["photo", "build", "photo"].compactMap { UIImage(named: $0) },
            isHot: false,
            backgroundColor: Constants.limeColor,
            primaryTextColor: Constants.darkTextColor,
            secondaryTextColor: Constants.mutedDarkTextColor
        )

        segmentPosts = [
            [campusPost, popularPost],
            [],
            [popularPost, campusPost]
        ]
    }
}

struct HomePost {
    let sourcePost: Post?
    let author: String
    let school: String
    let time: String
    let body: String
    let avatarImage: UIImage?
    let heroImage: UIImage?
    let thumbnailImages: [UIImage]
    let isHot: Bool
    let backgroundColor: UIColor
    let primaryTextColor: UIColor
    let secondaryTextColor: UIColor
}
