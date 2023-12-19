//
//  AppRepositoryImpl.swift
//  LocalStorage
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import DataMapper
import Repository
import GMDNetwork

public struct AppRepositoryImpl: AppRepository {
	public let dataMapper: AppDataMapper
	public let session: Session
	
	public init(
		dataMapper: AppDataMapper,
		session: Session
	) {
		self.dataMapper = dataMapper
		self.session = session
	}
}

extension AppRepositoryImpl {
	public func registerDeviceToken(_ deviceToken: String) async throws {
		let requestDto = dataMapper.mapToRegisterDeviceTokenRequestDTO(from: deviceToken)
		_ = try await Provider<AppAPI>.init(session: session)
			.request(AppAPI.registerDeviceToken(requestDto), type: VoidResponse.self)
		return
	}
}
