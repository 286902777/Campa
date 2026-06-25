import Foundation

final class ProfileViewModel {
    let name = NSLocalizedString("Nicki Mullins", comment: "Profile name")
    let school = NSLocalizedString("Yonsei University", comment: "Profile school")
    let location = NSLocalizedString("Seoul, Korea", comment: "Profile location")
    let followingCount = "20"
    let followersCount = "336"
    let postsCount = "24"
    let followingTitle = NSLocalizedString("Following", comment: "Following count title")
    let followersTitle = NSLocalizedString("Followers", comment: "Followers count title")
    let postsTitle = NSLocalizedString("Posts", comment: "Posts count title")

    let postAuthor = NSLocalizedString("Jiwoo", comment: "Post author")
    let postSchool = NSLocalizedString("Korea University", comment: "Post school")
    let postTime = NSLocalizedString("2 hours ago", comment: "Post time")
    let postText = NSLocalizedString(
        "Springtime on campus, the cherry blossoms are in full bloom, welcome to come and take photos!",
        comment: "Profile post text"
    )
}
