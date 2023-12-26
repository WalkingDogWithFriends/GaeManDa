//
//  Interceptor.swift
//  LocalStorage
//
//  Created by 김영균 on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol Interceptor {
	func adapt(_ request: URLRequest) -> URLRequest
}
