//
//  Date+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/14.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public extension Date {
	/// Date를 String으로 변환
	/// - Parameter format: 날짜 포맷 (ex: "yyyy-MM-dd")
	func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
}
