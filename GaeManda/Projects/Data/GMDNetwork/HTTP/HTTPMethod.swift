//
//  HTTPMethod.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
		/// `DELETE` method.
		public static let delete = HTTPMethod(rawValue: "DELETE")
		/// `GET` method.
		public static let get = HTTPMethod(rawValue: "GET")
		/// `POST` method.
		public static let post = HTTPMethod(rawValue: "POST")
		/// `PUT` method.
		public static let put = HTTPMethod(rawValue: "PUT")
		/// `PATCH` method.
		public static let patch = HTTPMethod(rawValue: "PATCH")
	
		public let rawValue: String

		public init(rawValue: String) {
				self.rawValue = rawValue
		}
}
