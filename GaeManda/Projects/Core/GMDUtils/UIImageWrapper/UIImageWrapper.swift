//
//  UIImageWrapper.swift
//  GMDExtensions
//
//  Created by jung on 11/30/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public struct UIImageWrapper {
	public var image: UIImage?
	
	public init(_ image: UIImage?) {
		self.image = image
	}
	
	/// utf8타입의 String으로 변환합니다.
	public var toUTF8: String {
		guard
			let image = image,
			let imageData = image.pngData(),
			let imageString = String(data: imageData, encoding: .utf8)
		else { return "" }
		
		return imageString
	}
	
	// Data타입으로 변환합니다.
	public var toData: Data {
		guard
			let image = image,
			let imageData = image.pngData()
		else { return Data() }
		
		return imageData
	}
}
