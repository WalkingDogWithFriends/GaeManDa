//
//  GeocodeRepositoryImpl.swift
//  DTO
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DataMapper
import DTO
import Entity
import GMDNetwork
import Repository

public struct GeocodeRepositoryImpl: GeocodeRepository {
	private let session: URLSession
	private let dataMapper: GeocodeDataMapper
	
	public init(
		dataMapper: GeocodeDataMapper,
		session: URLSession = URLSession(configuration: .default)
	) {
		self.dataMapper = dataMapper
		self.session = session
	}
	
	public func fetchGeocode(for address: String) -> Single<Location> {
		return Single.create { single in
			Task {
				do {
					let urlRequest = try GeocodeAPI.fetchGeocode(query: address).asURLRequest()
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

fileprivate extension GeocodeRepositoryImpl {
	func handleGeocodeResponse(
		data: Data,
		response: URLResponse,
		single: @escaping (SingleEvent<Location>) -> Void
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
	
	func decodeGeocode(from data: Data) throws -> Location {
		let geocode = try JSONDecoder().decode(GeocodingResponseDTO.self, from: data)
		guard let address = geocode.addresses?.first else {
			throw NetworkError.networkFailed(reason: .jsonDecodingFailed)
		}
		guard let latitude = address.y, let longitude = address.x else {
			throw NetworkError.networkFailed(reason: .noData)
		}
				
		return dataMapper.mapToLocation(latitude: latitude, longitude: longitude)
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
