//
//  FileProvider.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct FileProvider<Target: TargetType> {
	public init() { }
	
	public func request<T: Decodable>(_ target: TargetType, type: T.Type) -> Result<T, Error> {
		do {
			let jsonUrl = try target.asFileURL()
			let data = try data(from: jsonUrl)
			let decodedData: T = try decode(from: data)
			return .success(decodedData)
		} catch {
			return .failure(error)
		}
	}
}

private extension FileProvider {
	func data(from url: URL) throws -> Data {
		do {
			let data = try Data(contentsOf: url)
			return data
		} catch {
			throw FileStorageError.noData(error: error)
		}
	}
	
	func decode<T: Decodable>(from data: Data) throws -> T {
		do {
			let decoder = JSONDecoder()
			let decoded = try decoder.decode(T.self, from: data)
			return decoded
		} catch {
			throw FileStorageError.jsonEncodingFailed(error: error)
		}
	}
}
