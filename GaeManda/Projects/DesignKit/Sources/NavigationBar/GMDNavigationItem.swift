//
//  GMDNavigationItem.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/14.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit

public enum GMDNavigationItemType {
	case setting
	case alarm
}

public final class GMDNavigationItem: UIButton {
	private let type: GMDNavigationItemType

	// MARK: Initializers
	public init(type: GMDNavigationItemType) {
		self.type = type
		super.init(frame: .zero)
		setConstraints()
		setImage()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: Private Methods
private extension GMDNavigationItem {
	func setConstraints() {
		self.snp.makeConstraints { make in
			make.width.height.equalTo(20)
		}		
	}
	
	func setImage() {
		switch type {
		case .setting:
			setImage(UIImage.iconSettings, for: .normal)
		case .alarm:
			setImage(UIImage.iconNotification, for: .normal)
		}
	}
}
