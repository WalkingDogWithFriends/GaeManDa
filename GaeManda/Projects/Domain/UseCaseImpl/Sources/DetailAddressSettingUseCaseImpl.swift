//
//  DetailAddressSettingUseCaseImpl.swift
//  Repository
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Repository
import UseCase

public struct DetailAddressSettingUseCaseImpl: DetailAddressSettingUseCase {
	private let geocodeRepository: GeocodeRepository
	
	public init(geocodeRepository: GeocodeRepository) {
		self.geocodeRepository = geocodeRepository
	}
}

public extension DetailAddressSettingUseCaseImpl {
	func fetchGeocode(for address: String) -> Single<(latitude: String, longitude: String)> {
		return geocodeRepository.fetchGeocode(for: address)
	}
}
