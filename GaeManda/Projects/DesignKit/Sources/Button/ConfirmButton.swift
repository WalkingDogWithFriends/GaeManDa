//
//  ConfirmButton.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/28.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public final class ConfirmButton: UIButton {
	// MARK: - Properties
	public var isPositive: Bool = true {
		didSet {
			isPositive ? setPositiveState() : setNegativeState()
		}
	}
	
	// MARK: - Initializers
	public init(title: String, isPositive: Bool = true) {
		super.init(frame: .zero)
		self.layer.cornerRadius = 4
		self.setTitleColor(.white, for: .normal)
		self.setTitle(title, for: .normal)
		self.titleLabel?.font = .b16
		
		defer { self.isPositive = isPositive }
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	private func setPositiveState() {
		backgroundColor = .green100
	}
	
	private func setNegativeState() {
		backgroundColor = .gray60
	}
}

public extension Reactive where Base: ConfirmButton {
	var isPositive: ControlProperty<Bool> {
		return controlProperty(
			editingEvents: [.allEditingEvents, .valueChanged],
			getter: { button in
				button.isPositive
			},
			setter: { button, isPositive in
				button.isPositive = isPositive
			}
		)
	}
}
