//
//  GeocodeRepository.swift
//  Repository
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift

public protocol GeocodeRepository {
	func fetchGeocode(for address: String) -> Single<(latitude: String, longitude: String)>
}
