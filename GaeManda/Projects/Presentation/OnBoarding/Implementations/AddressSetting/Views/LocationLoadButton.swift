//
//  LocationLoadButton.swift
//  OnBoarding
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DesignKit

final class LocationLoadButton: UIButton {
	private let buttonConfiguration: UIButton.Configuration = {
		var configuration = UIButton.Configuration.plain()
		configuration.image = UIImage.iconGps.withTintColor(.gmdWhite)
		configuration.imagePadding = 12
		configuration.attributedTitle = AttributedString("현재 위치 불러오기".attributedString(font: .b12, color: .white))
		configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
		configuration.background.backgroundColor = .black
		
		return configuration
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setAttributes()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setAttributes()
	}
}

fileprivate extension LocationLoadButton {
	func setAttributes() {
		self.configuration = buttonConfiguration
		self.tintColor = .white
		self.layer.cornerRadius = 4
	}
}
