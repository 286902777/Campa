//
//  AppInfo.swift
//  Campa
//
//  Created by myfy on 2026/6/25.
//

import Foundation

let CurrentUserIdKey = "currentUserId"

extension Notification.Name {
    static let postDidPublish = Notification.Name("postDidPublish")
    static let activityDidPublish = Notification.Name("activityDidPublish")
}
