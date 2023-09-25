//
//  UIViewController+Extensions.swift
//  Extensions
//
//  Created by jung on 2023/07/12.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import PhotosUI

public extension UIViewController {	
	func presentPHPickerView() {
		guard let self = self as? PHPickerViewControllerDelegate else { return }
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 1
		configuration.filter = .any(of: [.images, .not(.livePhotos)])
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		present(picker, animated: true)
	}
}
