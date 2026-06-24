import Foundation

final class HomeViewModel {
    let title = NSLocalizedString("Campa", comment: "Application title")
    let locationTitle = NSLocalizedString("Yonsei University", comment: "Home location title")
    let searchPlaceholder = NSLocalizedString("Search campus life", comment: "Home search placeholder")
    let featuredTitle = NSLocalizedString("Seoul campus connection", comment: "Home featured card title")
    let featuredSubtitle = NSLocalizedString("Find friends, classes and nearby events.", comment: "Home featured card subtitle")
    let categoryTitles = [
        NSLocalizedString("Trending", comment: "Home category"),
        NSLocalizedString("Events", comment: "Home category"),
        NSLocalizedString("Study", comment: "Home category"),
        NSLocalizedString("Food", comment: "Home category")
    ]
    let posts = [
        HomePost(
            imageName: "photo",
            title: NSLocalizedString("Hongdae weekend photo walk", comment: "Home post title"),
            subtitle: NSLocalizedString("Meet at Exit 8, 14:00", comment: "Home post subtitle"),
            tag: NSLocalizedString("Popular", comment: "Home post tag")
        ),
        HomePost(
            imageName: "build",
            title: NSLocalizedString("Campus flea market", comment: "Home post title"),
            subtitle: NSLocalizedString("Books, lamps and small furniture", comment: "Home post subtitle"),
            tag: NSLocalizedString("Today", comment: "Home post tag")
        )
    ]
}

struct HomePost {
    let imageName: String
    let title: String
    let subtitle: String
    let tag: String
}
