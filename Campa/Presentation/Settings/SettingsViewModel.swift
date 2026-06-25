import Foundation

final class SettingsViewModel {
    let title = NSLocalizedString("Settings", comment: "Settings screen title")
    let sections: [SettingsSection] = [
        SettingsSection(items: [
            SettingsItem(title: NSLocalizedString("Edit profile", comment: "Settings item"), iconName: "user_set", accessory: .arrow),
            SettingsItem(title: NSLocalizedString("Account security", comment: "Settings item"), iconName: "password", accessory: .arrow)
        ]),
        SettingsSection(items: [
            SettingsItem(title: NSLocalizedString("Notification", comment: "Settings item"), iconName: "bell", accessory: .switchControl(isOn: true)),
            SettingsItem(title: NSLocalizedString("Privacy", comment: "Settings item"), iconName: "select", accessory: .arrow),
            SettingsItem(title: NSLocalizedString("Blacklist", comment: "Settings item"), iconName: "close", accessory: .arrow)
        ]),
        SettingsSection(items: [
            SettingsItem(title: NSLocalizedString("Language", comment: "Settings item"), iconName: "location", accessory: .value(NSLocalizedString("English", comment: "Current language"))),
            SettingsItem(title: NSLocalizedString("Delete account", comment: "Settings item"), iconName: "delete", accessory: .arrow),
            SettingsItem(title: NSLocalizedString("Log out", comment: "Settings item"), iconName: "enter", accessory: .none)
        ])
    ]
}

struct SettingsSection {
    let items: [SettingsItem]
}

struct SettingsItem {
    enum Accessory {
        case arrow
        case switchControl(isOn: Bool)
        case value(String)
        case none
    }

    let title: String
    let iconName: String
    let accessory: Accessory
}
