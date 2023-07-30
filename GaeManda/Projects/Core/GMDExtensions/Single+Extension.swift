//
//  ObservableType+Extension.swift
//  GMDExtensions
//
//  Created by jung on 2023/07/25.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift

public extension Single {
	func ignoreTerminate() -> Observable<Element> {
		return self.asObservable().concat(Observable.never())
	}
}
