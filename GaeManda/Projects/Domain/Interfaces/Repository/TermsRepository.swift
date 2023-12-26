//
//  TermsRepository.swift
//  Repository
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift
import Entity

public protocol TermsRepository {
	func requestNotificationPermission() async throws -> Bool
	func requestLocationPermission()
	func fetchTerms() -> Single<Terms>
}
