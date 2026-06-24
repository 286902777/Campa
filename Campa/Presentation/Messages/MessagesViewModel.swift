import Foundation

final class MessagesViewModel {
    let title = NSLocalizedString("Message", comment: "Messages screen title")
    let inputPlaceholder = NSLocalizedString("Type message", comment: "Message input placeholder")
    let messages = [
        MessageBubble(
            text: NSLocalizedString("Hi! Are you going to the campus market today?", comment: "Incoming chat message"),
            isOutgoing: false
        ),
        MessageBubble(
            text: NSLocalizedString("Yes, I will be there after class.", comment: "Outgoing chat message"),
            isOutgoing: true
        ),
        MessageBubble(
            text: NSLocalizedString("Great. Meet near the main gate?", comment: "Incoming chat message"),
            isOutgoing: false
        ),
        MessageBubble(
            text: NSLocalizedString("Sure, see you at 5.", comment: "Outgoing chat message"),
            isOutgoing: true
        )
    ]
}

struct MessageBubble {
    let text: String
    let isOutgoing: Bool
}
