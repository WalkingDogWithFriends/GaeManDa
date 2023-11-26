//
//  AddDogCharacterButton.swift
//  DesignKit
//
//  Created by jung on 11/23/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public final class AddDogCharacterButton: UIButton {
	public init() {
		super.init(frame: .zero)
		
		var configuration = UIButton.Configuration.filled()
		configuration.image = UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: 12))
		configuration.imagePadding = 16
		configuration.background.backgroundColor = .black
		configuration.background.cornerRadius = 4
		
		var titleAttr = AttributedString.init("우리 아이 성격 추가하기")
		titleAttr.font = .r15
		configuration.attributedTitle = titleAttr
		
		self.configuration = configuration
	}
	
	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
