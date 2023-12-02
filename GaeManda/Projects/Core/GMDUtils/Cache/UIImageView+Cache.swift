//
//  UIImageView+Cache.swift
//  GMDExtensions
//
//  Created by 김영균 on 12/3/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UIImageView {
	@MainActor
	func loadImage(urlString: String) {
		Task {
			guard let data = await ImageLoader.shared.downloadImage(taskKey: self, urlString: urlString) else { return }
			self.image = UIImage(data: data)
		}
	}
	
	@MainActor
	func cancel() {
		ImageLoader.shared.cancelIfPossible(taskKey: self)
	}
}
