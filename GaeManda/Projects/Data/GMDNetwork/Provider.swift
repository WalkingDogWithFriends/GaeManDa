//
//  Provider.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift

public enum StubBehavior {
	// not use stub
	case never
	// use stub
	case immediate
}

public struct Provider<Target: TargetType> {
	private let stubBehavior: StubBehavior
	private let session: Session
	
	public init(
		stubBehavior: StubBehavior = .never,
		session: Session = Session()
	) {
		self.stubBehavior = stubBehavior
		self.session = session
	}
	
	public func request<T: Decodable>(_ target: TargetType, type: T.Type) -> Single<T> {
		switch stubBehavior {
		case .never:
			return requestObject(target, type: type)
			
		case .immediate:
			return requestStub(target, type: type)
		}
	}
}

private extension Provider {
	func requestObject<T: Decodable>(_ target: TargetType, type: T.Type) -> Single<T> {
		return Single<T>.create { single in
			do {
				let urlRequest = try target.asURLRequest()
				Task {
					let data = try await session.request(request: urlRequest)
					let decoder = JSONDecoder()
					let decodedData = try decoder.decode(T.self, from: data)
					single(.success(decodedData))
				}
			} catch {
				single(.failure(error))
			}
			return Disposables.create()
		}
	}
	
	func requestStub<T: Decodable>(_ target: TargetType, type: T.Type) -> Single<T> {
		return Single<T>.create { single in
			do {
				let data = target.sampleData
				let decoder = JSONDecoder()
				let decodedData = try decoder.decode(T.self, from: data)
				single(.success(decodedData))
			} catch {
				single(.failure(error))
			}
			return Disposables.create()
		}
	}
}
