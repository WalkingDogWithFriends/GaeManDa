//
//  NoticeLabel.swift
//  OnBoardingImpl
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import DesignKit

final class NoticeLabel: UILabel {
	private enum Constant {
		static let text = """
 사생활 보호를 위해 등록된 주소에서 반경 500M 내에는
 보호자의 위치가 노출되지 않습니다.
 주소를 비롯한 보호자의 개인정보는 타인에게 공유되지
 않으니 안심하고 서비스를 이용해주세요.
 """
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

fileprivate extension NoticeLabel {
	func setAttributes() {
		self.numberOfLines = 0
		self.lineBreakMode = .byWordWrapping
		self.attributedText = Constant.text.attributedString(
			font: .r12,
			color: .black,
			lineSpacing: 12,
			lineHeightMultiple: 0.73
		)
	}
}
