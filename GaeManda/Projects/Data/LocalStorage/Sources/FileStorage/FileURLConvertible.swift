//
//  FileURLConvertible.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol FileURLConvertible {
	func asFileURL() throws -> URL
}

extension FileURLConvertible {
	public var fileURL: URL? { try? asFileURL() }
}

extension URL: FileURLConvertible {
	public func asFileURL() throws -> URL { self }
}
