//
//  GeocodingRepositoryImpl.swift
//  DTO
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DTO
import GMDNetwork
import Repository

public struct GeocodingRepositoryImpl: GeocodeRepository {
	private let session: URLSession
	
	public init(session: URLSession = URLSession(configuration: .default)) {
		self.session = session
	}
	
	public func fetchGeocode(for address: String) -> Single<(latitude: String, longitude: String)> {
		return Single.create { single in
			Task {
				do {
					let urlRequest = try GeocodingAPI.fetchGeocode(query: address).asURLRequest()
					let (data, response) = try await session.data(for: urlRequest)
					handleGeocodeResponse(data: data, response: response, single: single)
				} catch {
					single(.failure(error))
				}
			}
			return Disposables.create()
		}
	}
}
fileprivate extension GeocodingRepositoryImpl {
	func handleGeocodeResponse(
		data: Data,
		response: URLResponse,
		single: @escaping (SingleEvent<(latitude: String, longitude: String)>) -> Void
	) {
		guard let httpURLResponse = response as? HTTPURLResponse else {
			single(.failure(NetworkError.networkFailed(reason: .noHttpURLRepsonse)))
			return
		}
		
		let statusCode = httpURLResponse.statusCode
		if 200..<300 ~= statusCode {
			do {
				let decodedData = try decodeGeocode(from: data)
				single(.success(decodedData))
			} catch {
				single(.failure(error))
			}
		} else {
			do {
				try decodeError(from: data)
			} catch {
				single(.failure(error))
			}
		}
	}
	
	func decodeGeocode(from data: Data) throws -> (latitude: String, longitude: String) {
		let geocode = try JSONDecoder().decode(GeocodeResponseDTO.self, from: data)
		guard let address = geocode.addresses?.first else {
			throw NetworkError.networkFailed(reason: .jsonDecodingFailed)
		}
		guard let latitude = address.y, let longitude = address.x else {
			throw NetworkError.networkFailed(reason: .noData)
		}
		return (latitude: latitude, longitude: longitude)
	}
	
	func decodeError(from data: Data) throws {
		let error = try JSONDecoder().decode(GeocodingErrorResponseDTO.self, from: data)
		guard let errorCodeStr = error.error?.errorCode, let errorCode = Int(errorCodeStr) else {
			return
		}
		if 400..<500 ~= errorCode {
			throw NetworkError.networkFailed(reason: .clientError(errorCode: errorCode))
		} else {
			throw NetworkError.networkFailed(reason: .serverError(errorCode: errorCode))
		}
	}
}
