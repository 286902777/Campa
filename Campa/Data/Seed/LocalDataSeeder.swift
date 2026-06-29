import CoreData
import Foundation

final class LocalDataSeeder {
    static let shared = LocalDataSeeder()

    private enum Constants {
        static let seedMarkerEmail = "maxwell@local.campa"
        static let defaultPasswordHash = "local-seed-password"
    }

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }

    func seedIfNeeded() {
        guard !hasSeededData() else {
            ensureCurrentUser()
            return
        }

        let users = makeUsers()
        let now = Date()
        users.forEach { item in
            let user = User(context: context)
            user.id = item.id
            user.email = item.email
            user.passwordHash = Constants.defaultPasswordHash
            user.nickname = item.name
            user.avatarLocalPath = item.avatar
            user.school = item.location
            user.location = item.location
            user.isCurrentUser = false
            user.createdAt = now
            user.updatedAt = now
        }

        guard let savedUsers = try? context.fetch(User.fetchRequest()) else {
            context.rollback()
            return
        }

        let usersByEmail = Dictionary(uniqueKeysWithValues: savedUsers.compactMap { user -> (String, User)? in
            guard let email = user.email else { return nil }
            return (email, user)
        })

        makePosts().enumerated().forEach { index, item in
            guard let author = usersByEmail[item.authorEmail] else { return }

            let post = Post(context: context)
            post.id = UUID()
            post.author = author
            post.title = String(item.content.prefix(30))
            post.content = item.content
            post.addressText = item.location
            post.latitude = 0
            post.longitude = 0
            post.likeCount = Int32(18 + index * 7)
            post.commentCount = 0
            post.createdAt = Calendar.current.date(byAdding: .hour, value: -(index + 2), to: now) ?? now
            post.updatedAt = post.createdAt

            item.images.enumerated().forEach { imageIndex, imageName in
                let image = PostImage(context: context)
                image.id = UUID()
                image.post = post
                image.localPath = imageName
                image.sortIndex = Int16(imageIndex)
                image.createdAt = post.createdAt
            }

            let comment = PostComment(context: context)
            comment.id = UUID()
            comment.post = post
            comment.author = savedUsers[(index + 1) % savedUsers.count]
            comment.content = item.comment
            comment.createdAt = Calendar.current.date(byAdding: .minute, value: 18, to: post.createdAt) ?? post.createdAt
            comment.updatedAt = comment.createdAt
            post.commentCount = 1
        }

        makeActivities().forEach { item in
            let author = usersByEmail[Constants.seedMarkerEmail] ?? savedUsers.first
            guard let author else { return }

            let activity = Activity(context: context)
            activity.id = UUID()
            activity.author = author
            activity.title = item.title
            activity.content = item.title
            activity.addressText = item.location
            activity.latitude = 0
            activity.longitude = 0
            activity.startAt = item.startAt
            activity.endAt = item.endAt
            activity.maxParticipants = 0
            activity.status = ActivityStatus.published.rawValue
            activity.createdAt = item.startAt ?? now
            activity.updatedAt = activity.createdAt

            item.images.enumerated().forEach { imageIndex, imageName in
                let image = ActivityImage(context: context)
                image.id = UUID()
                image.activity = activity
                image.localPath = imageName
                image.sortIndex = Int16(imageIndex)
                image.createdAt = activity.createdAt
            }

            let owner = ActivityParticipant(context: context)
            owner.id = UUID()
            owner.activity = activity
            owner.user = author
            owner.role = ActivityParticipantRole.owner.rawValue
            owner.status = ActivityParticipantStatus.joined.rawValue
            owner.joinedAt = activity.createdAt
        }

        do {
            try context.save()
            ensureCurrentUser()
        } catch {
            context.rollback()
        }
    }

    private func hasSeededData() -> Bool {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email == %@", Constants.seedMarkerEmail)
        return ((try? context.count(for: request)) ?? 0) > 0
    }

    private func ensureCurrentUser() {
        let currentUserId = UserDefaults.standard.string(forKey: CurrentUserIdKey) ?? ""
        guard currentUserId.isEmpty else { return }

        let request = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email == %@", Constants.seedMarkerEmail)

        guard let user = try? context.fetch(request).first else {
            return
        }

        user.isCurrentUser = true
        user.updatedAt = Date()
        try? context.save()
        UserDefaults.standard.set(user.id.uuidString, forKey: CurrentUserIdKey)
    }

    private func makeUsers() -> [SeedUser] {
        [
            SeedUser(id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!, name: "Maxwell", email: Constants.seedMarkerEmail, avatar: "下载 - 2026-06-24T113213.517.jpg", location: "Yonsei University"),
            SeedUser(id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!, name: "Kerr", email: "kerr@local.campa", avatar: "下载 - 2026-06-24T113222.724.jpg", location: "Sungkyunkwan University"),
            SeedUser(id: UUID(uuidString: "10000000-0000-0000-0000-000000000003")!, name: "Roman", email: "roman@local.campa", avatar: "Darcyyyyyy (1).jpg", location: "Sogang University"),
            SeedUser(id: UUID(uuidString: "10000000-0000-0000-0000-000000000004")!, name: "Olivia", email: "olivia@local.campa", avatar: "Bandana hairstyle.jpg", location: "Hanyang University"),
            SeedUser(id: UUID(uuidString: "10000000-0000-0000-0000-000000000005")!, name: "Gabriella", email: "gabriella@local.campa", avatar: "cyandra millionaires.jpg", location: "Chung-Ang University"),
            SeedUser(id: UUID(uuidString: "10000000-0000-0000-0000-000000000006")!, name: "Holly", email: "holly@local.campa", avatar: "下载 - 2026-06-24T112624.868.jpg", location: "Yonsei University")
        ]
    }

    private func makePosts() -> [SeedPost] {
        [
            SeedPost(authorEmail: Constants.seedMarkerEmail, content: "This semester's calculus final is extremely tough. I'm searching for last year's exam papers with full solutions. I can trade my physics lab report materials if anyone has the review sheets!", images: ["study asthetic wallpaper.jpg", "Work Time.jpg", "下载 - 2026-06-24T113949.804.jpg"], location: "Yonsei University", comment: "This final is literally impossible... I also need review materials urgently"),
            SeedPost(authorEmail: "kerr@local.campa", content: "Bulgogi set meal is newly released today! Generous meat portion, free rice refills, and warm soup -- highly recommended for lunch. The queue gets extremely long after 11:40, so come early.", images: ["下载 - 2026-06-24T114943.579.jpg", "下载 - 2026-06-24T114949.689.jpg", "下载 - 2026-06-24T144118.185.jpg"], location: "Sungkyunkwan University", comment: "I tried it today! The portion is really big, totally worth the price!"),
            SeedPost(authorEmail: "roman@local.campa", content: "Graduating soon, clearing out unused study supplies.", images: ["下载 - 2026-06-24T145005.083.jpg", "下载 - 2026-06-24T144929.690.jpg", "下载 - 2026-06-24T144854.364.jpg"], location: "Sogang University", comment: "Can you send more photos of the book condition? Thanks!"),
            SeedPost(authorEmail: "olivia@local.campa", content: "Looking for one roommate for next semester dorm accommodation. I'm quiet, keep the room clean, and stay out most days for outdoor activities. Non-smoker only, no loud noise late at night. Message me if interested!", images: ["下载 - 2026-06-24T144440.485.jpg", "下载 - 2026-06-24T144446.804.jpg", "下载 - 2026-06-24T144458.674.jpg"], location: "Hanyang University", comment: "Hi! I'm looking for a roommate too! Non-smoker and quiet habit."),
            SeedPost(authorEmail: "gabriella@local.campa", content: "I've tried almost every corner of our library! The 4th-floor lounge area has large windows, soft lighting, and fewer crowds. No noisy talking or running. Perfect for writing papers and reviewing for finals.", images: ["college library #collegeasthetic #collegelife_.jpg", "下载 - 2026-06-24T150139.087.jpg", "cloudy library view.jpg"], location: "Chung-Ang University", comment: "Thanks for sharing! This is such a useful campus tip!"),
            SeedPost(authorEmail: "holly@local.campa", content: "The campus night view is incredibly beautiful recently! The main road lights and playground neon signs make the whole campus warm and cozy.", images: ["Yonsei University.jpg", "yonsei university🇰🇷.jpg", "1003880573234309683.jpg"], location: "Yonsei University", comment: "I totally agree! The night breeze is so comfortable lately.")
        ]
    }

    private func makeActivities() -> [SeedActivity] {
        [
            SeedActivity(title: "Campus Original Art Works Exhibition", startAt: makeDate(month: 7, day: 1, hour: 10), endAt: makeDate(month: 7, day: 5, hour: 10), images: ["下载 - 2026-06-24T163949.121.jpg", "Museum.jpg"], location: "Hongik University"),
            SeedActivity(title: "Inter-Class Friendly Basketball Tournament", startAt: makeDate(month: 7, day: 8, hour: 14), endAt: nil, images: ["basketball photography.jpg", "2021 Boys Basketball.jpg"], location: "Dongguk University"),
            SeedActivity(title: "Summer Internship & Career Planning Lecture", startAt: makeDate(month: 7, day: 3, hour: 13), endAt: nil, images: ["下载 - 2026-06-24T165840.695.jpg", "下载 - 2026-06-24T165859.237.jpg"], location: "Sejong University")
        ]
    }

    private func makeDate(month: Int, day: Int, hour: Int) -> Date? {
        Calendar.current.date(from: DateComponents(year: 2026, month: month, day: day, hour: hour))
    }
}

private struct SeedUser {
    let id: UUID
    let name: String
    let email: String
    let avatar: String
    let location: String
}

private struct SeedPost {
    let authorEmail: String
    let content: String
    let images: [String]
    let location: String
    let comment: String
}

private struct SeedActivity {
    let title: String
    let startAt: Date?
    let endAt: Date?
    let images: [String]
    let location: String
}
