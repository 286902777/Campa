import CoreData
import Foundation

final class UserRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }

    func createUser(nickname: String, isCurrentUser: Bool) -> Result<User, PersistenceError> {
        guard !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .failure(.invalidTitle)
        }

        if isCurrentUser {
            clearCurrentUserFlag()
        }

        let now = Date()
        let user = User(context: context)
        user.id = UUID()
        user.nickname = nickname
        user.isCurrentUser = isCurrentUser
        user.createdAt = now
        user.updatedAt = now

        return saveAndReturn(user)
    }

    func createRegisteredCurrentUser(
        email: String,
        passwordHash: String,
        nickname: String,
        birthday: Date?,
        location: String?,
        gender: String?,
        avatarLocalPath: String? = nil
    ) -> Result<User, PersistenceError> {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNickname.isEmpty else {
            return .failure(.invalidTitle)
        }

        clearCurrentUserFlag()

        let now = Date()
        let user = User(context: context)
        user.id = UUID()
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        user.passwordHash = passwordHash
        user.nickname = trimmedNickname
        user.birthday = birthday
        user.location = location?.trimmingCharacters(in: .whitespacesAndNewlines)
        user.gender = gender
        user.avatarLocalPath = avatarLocalPath
        user.isCurrentUser = true
        user.createdAt = now
        user.updatedAt = now

        return saveAndReturn(user)
    }

    func fetchCurrentUser() -> Result<User, PersistenceError> {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "isCurrentUser == YES")

        do {
            guard let user = try context.fetch(request).first else {
                return .failure(.missingCurrentUser)
            }
            return .success(user)
        } catch {
            return .failure(.coreDataSaveFailed)
        }
    }

    func addRelation(from sourceUser: User, to targetUser: User, type: UserRelationType) -> Result<UserRelation, PersistenceError> {
        if case .success(true) = hasRelation(from: sourceUser, to: targetUser, type: type) {
            return .failure(.duplicateRelation)
        }

        let relation = UserRelation(context: context)
        relation.id = UUID()
        relation.sourceUser = sourceUser
        relation.targetUser = targetUser
        relation.type = type.rawValue
        relation.createdAt = Date()

        return saveAndReturn(relation)
    }

    func removeRelation(from sourceUser: User, to targetUser: User, type: UserRelationType) -> Result<Void, PersistenceError> {
        let request = UserRelation.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "sourceUser == %@ AND targetUser == %@ AND type == %@",
            sourceUser,
            targetUser,
            type.rawValue
        )

        do {
            if let relation = try context.fetch(request).first {
                context.delete(relation)
                try context.save()
            }
            return .success(())
        } catch {
            return .failure(.coreDataSaveFailed)
        }
    }

    func hasRelation(from sourceUser: User, to targetUser: User, type: UserRelationType) -> Result<Bool, PersistenceError> {
        let request = UserRelation.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "sourceUser == %@ AND targetUser == %@ AND type == %@",
            sourceUser,
            targetUser,
            type.rawValue
        )

        do {
            return .success(try context.count(for: request) > 0)
        } catch {
            return .failure(.coreDataSaveFailed)
        }
    }

    private func clearCurrentUserFlag() {
        let request = User.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrentUser == YES")

        guard let users = try? context.fetch(request) else { return }
        let now = Date()
        users.forEach {
            $0.isCurrentUser = false
            $0.updatedAt = now
        }
    }

    private func saveAndReturn<T>(_ object: T) -> Result<T, PersistenceError> {
        do {
            try context.save()
            return .success(object)
        } catch {
            return .failure(.coreDataSaveFailed)
        }
    }
}
