import Foundation

final class MessageListViewModel {
    let title = NSLocalizedString("Message", comment: "Message list screen title")
    let messages: [MessageListItem] = [
        MessageListItem(
            name: NSLocalizedString("Keane Glass", comment: "Message sender name"),
            preview: NSLocalizedString("Yo! Any fun plans brewing for later?", comment: "Message preview"),
            time: NSLocalizedString("7:23 AM", comment: "Message timestamp"),
            unreadCount: 4
        ),
        MessageListItem(
            name: NSLocalizedString("Keane Glass", comment: "Message sender name"),
            preview: NSLocalizedString("Yo! Any fun plans brewing for later?", comment: "Message preview"),
            time: NSLocalizedString("7:23 AM", comment: "Message timestamp"),
            unreadCount: nil
        ),
        MessageListItem(
            name: NSLocalizedString("Keane Glass", comment: "Message sender name"),
            preview: NSLocalizedString("Yo! Any fun plans brewing for later?", comment: "Message preview"),
            time: NSLocalizedString("7:23 AM", comment: "Message timestamp"),
            unreadCount: nil
        ),
        MessageListItem(
            name: NSLocalizedString("Keane Glass", comment: "Message sender name"),
            preview: NSLocalizedString("Yo! Any fun plans brewing for later?", comment: "Message preview"),
            time: NSLocalizedString("7:23 AM", comment: "Message timestamp"),
            unreadCount: nil
        )
    ]
}

struct MessageListItem {
    let name: String
    let preview: String
    let time: String
    let unreadCount: Int?
}
