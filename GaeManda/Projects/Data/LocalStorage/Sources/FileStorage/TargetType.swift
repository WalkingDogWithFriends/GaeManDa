//
//  TargetType.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol TargetType: FileURLConvertible {
	var filename: String { get }
	var task: TaskType { get }
	var fileType: FileType { get }
}

extension TargetType {
	public func asFileURL() throws -> URL {
		guard
			let bundlePath = Bundle.main.path(forResource: "Data_LocalStorage", ofType: "bundle"),
			let bundle = Bundle(path: bundlePath),
			let url = bundle.url(forResource: filename, withExtension: fileType.rawValue) else {
			throw FileStorageError.invalidURL
		}
		return url
	}
}
