//
//  IndicatorView.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit

final class IndicatorView: UIStackView {
	var indicatorCount: Int = 0 {
		didSet {
			indicators = Array(indicatorViews[0..<indicatorCount])
			setupUI()
		}
	}
	
	private lazy var indicatorViews = [firstView, secondView, thirdView]
	private var indicators: [UIView] = []
	
	// MARK: - UI Components
	private let firstView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.backgroundColor = .green60
		
		return view
	}()
	
	private let secondView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.backgroundColor = .gray40
		
		return view
	}()
	
	private let thirdView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.backgroundColor = .gray40
		
		return view
	}()
	
	// MARK: - Initializers
	init() {
		super.init(frame: .zero)
		axis = .horizontal
		spacing = 8
		alignment = .fill
		distribution = .fillEqually
	}
	
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError()
	}
	
	// MARK: - layoutSubviews
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// make Indicator views round
		indicators.forEach { $0.layer.cornerRadius = $0.bounds.width / 2 }
	}
}

// MARK: - UI Setting
private extension IndicatorView {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		indicators.forEach { addArrangedSubview($0) }
	}
	
	func setConstraints() {
		indicators.forEach {
			$0.snp.makeConstraints { make in
				make.width.height.equalTo(19)
			}
		}
	}
}

// MARK: indicatorView Action
extension IndicatorView {
	func collectionViewDidChange(index: Int) {
		guard index >= 0, index < indicatorCount else { return }
		
		// adopt green60 to selected Index View,
		// else adopt gray40
		for (idx, item) in indicators.enumerated() {
			item.backgroundColor = idx == index ? .green60 : .gray40
		}
	}
}
