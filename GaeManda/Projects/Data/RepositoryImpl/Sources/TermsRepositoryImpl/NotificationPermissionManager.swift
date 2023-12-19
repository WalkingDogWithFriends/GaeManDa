//
//  NotificationPermissionManager.swift
//  DataMapper
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import FirebaseCore
import FirebaseMessaging

public protocol NotificationPermissionManager {
	func requestNotificationPermission() async throws -> Bool
}

public struct NotificationPermissionManagerImpl {
	public init() {}
}

extension NotificationPermissionManagerImpl: NotificationPermissionManager {
	public func requestNotificationPermission() async throws -> Bool {
		let center = UNUserNotificationCenter.current()
		return try await center.requestAuthorization(options: [.alert, .sound, .badge])
	}
}
