import CoreData
import Foundation

final class ChatRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }

    func createConversation(type: ChatConversationType, title: String?, participants: [User]) -> Result<ChatConversation, PersistenceError> {
        let now = Date()
        let conversation = ChatConversation(context: context)
        conversation.id = UUID()
        conversation.type = type.rawValue
        conversation.title = title
        conversation.unreadCount = 0
        conversation.createdAt = now
        conversation.updatedAt = now

        participants.forEach { user in
            let participant = ChatParticipant(context: context)
            participant.id = UUID()
            participant.user = user
            participant.conversation = conversation
            participant.role = ChatParticipantRole.member.rawValue
            participant.joinedAt = now
        }

        return saveAndReturn(conversation)
    }

    func insertTextMessage(_ text: String, from sender: User, in conversation: ChatConversation) -> Result<ChatMessage, PersistenceError> {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .failure(.invalidContent)
        }

        let now = Date()
        let message = ChatMessage(context: context)
        message.id = UUID()
        message.content = text
        message.messageType = ChatMessageType.text.rawValue
        message.status = ChatMessageStatus.sent.rawValue
        message.sentAt = now
        message.createdAt = now
        message.sender = sender
        message.conversation = conversation

        conversation.lastMessageText = text
        conversation.lastMessageAt = now
        conversation.updatedAt = now

        return saveAndReturn(message)
    }

    func fetchConversations() -> Result<[ChatConversation], PersistenceError> {
        let request = ChatConversation.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "lastMessageAt", ascending: false),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            return .success(try context.fetch(request))
        } catch {
            return .failure(.coreDataSaveFailed)
        }
    }

    func fetchMessages(in conversation: ChatConversation) -> Result<[ChatMessage], PersistenceError> {
        let request = ChatMessage.fetchRequest()
        request.predicate = NSPredicate(format: "conversation == %@", conversation)
        request.sortDescriptors = [NSSortDescriptor(key: "sentAt", ascending: true)]

        do {
            return .success(try context.fetch(request))
        } catch {
            return .failure(.coreDataSaveFailed)
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
