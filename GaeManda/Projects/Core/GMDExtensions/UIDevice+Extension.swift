//
//  UIDevice+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/11.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UIDevice {
	static var safeAreaBottomHeight: CGFloat {
		guard let mainWindowScene = UIApplication.shared.connectedScenes
			.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
					let mainWindow = mainWindowScene.windows.first else {
			return 0
		}
		
		return mainWindow.safeAreaInsets.bottom
	}
	
	static var safeAreaTopHeight: CGFloat {
		guard let mainWindowScene = UIApplication.shared.connectedScenes
			.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
					let mainWindow = mainWindowScene.windows.first else {
			return 0
		}
		
		return mainWindow.safeAreaInsets.top
	}
}
