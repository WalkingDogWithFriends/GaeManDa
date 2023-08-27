//
//  ConfirmButton.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/28.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public final class ConfirmButton: UIButton {
	// MARK: - Properties
	public override var isEnabled: Bool {
		didSet {
			isEnabled ? buttonEnable() : buttonDisable()
		}
	}
	
	// MARK: - Initializers
	public init(title: String) {
		super.init(frame: .zero)
		
		self.layer.cornerRadius = 4
		self.backgroundColor = .gray60
		self.setTitleColor(.white, for: .normal)
		self.setTitle(title, for: .normal)
		self.titleLabel?.font = .b16
		self.isEnabled = false
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	private func buttonEnable() {
		backgroundColor = .green100
	}
	
	private func buttonDisable() {
		backgroundColor = .gray60
	}
}

public extension Reactive where Base: ConfirmButton {
	var isEnabled: ControlProperty<Bool> {
		return controlProperty(
			editingEvents: [.allEditingEvents, .valueChanged],
			getter: { button in
				button.isEnabled
			},
			setter: { button, isEnabled in
				button.isEnabled = isEnabled
			}
		)
	}
}
