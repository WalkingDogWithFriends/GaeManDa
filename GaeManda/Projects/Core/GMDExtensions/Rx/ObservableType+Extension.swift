//
//  ObservableType+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 10/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift

extension ObservableType {
	func map<R>(to value: R) -> Observable<R> {
		return map { _ in value }
	}
	
	func unwrap<T>() -> Observable<T> where Element == T? {
		return self
			.filter { $0 != nil }
			.map { $0! }
	}
}
