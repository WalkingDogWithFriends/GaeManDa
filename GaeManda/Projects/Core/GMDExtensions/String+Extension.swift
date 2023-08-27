//
//  String+Extension.swift
//  GMDExtensions
//
//  Created by jung on 2023/08/27.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public extension String {
	/// count만큼의 Suffix를 return 합니다.
	/// ex) "01234".trimmingSuffic(with: 2) == "01"
	func trimmingSuffix(with count: Int) -> String {
		guard self.count >= count else {
			return self
		}
		let index = self.index(self.startIndex, offsetBy: count)
		return String(self[..<index])
	}
}
